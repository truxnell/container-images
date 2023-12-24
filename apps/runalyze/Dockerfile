# syntax=docker/dockerfile:1.4


FROM debian:bullseye-20231009
ARG CONF_APP_ROOT=/app/runalyze
ARG CONF_USER=dockusr
ARG CONF_USER_ID=1001
ARG CONF_GROUP=dockusr
ARG CONF_GROUP_ID=1001

# Specifies about of this dockerfile/installation
# - the release artefact is stored in the GIT repository
# - download of the timezone correction database (wget -O ./data/timezone.sqlite https://cdn.runalyze.com/update/timezone.sqlite) not done in docker, because it is part of the source/GIT-repository
# - "restart" queue-processing with a cron-job periodically
# - the best method to provide the SRTM data is via a docker volume to '$CONF_APP_ROOT/data/srtm'

RUN addgroup --gid $CONF_GROUP_ID $CONF_GROUP && \
  adduser --uid $CONF_USER_ID --ingroup $CONF_GROUP --disabled-password --gecos "" $CONF_USER


RUN apt-get update \
  && apt-get install -y --no-install-recommends runit curl libarchive-tools nginx php7.4-fpm \
  && apt-get install -y --no-install-recommends php7.4-intl php7.4-mysql php7.4-mbstring php7.4-xml php7.4-curl php7.4-zip php7.4-gettext php7.4-bcmath \
  # sqlite for timezones
  php7.4-sqlite3 sqlite3 libsqlite3-mod-spatialite \
  && apt-get install -y --no-install-recommends perl gettext libxml2 python3 python3-pip python3-setuptools inkscape \
  && apt-get install -y --no-install-recommends librsvg2-bin librsvg2-common \
  && apt-get install -y --no-install-recommends locales && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen \
  # install python dependencies for poster generation (all from vendor/runalyze/GpxTrackPoster/requirements.txt); i don't use "-r requirements.txt" because this is not yet available
  && pip3 install --no-cache-dir appdirs==1.4.0 gpxpy==1.0.0 pyparsing==2.0.7 svgwrite==1.1.6 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*


# nginx site
#COPY --chmod="700" runit/ /etc/service/
COPY --chmod="644" config/nginx/ /etc/nginx/
#COPY --chmod="640" logrotate.d /etc/logrotate.d

# Create Runit service directories and scripts
RUN mkdir -p /etc/service/nginx /etc/service/php-fpm /etc/service/queue

# Create the 'run' script for Nginx
RUN echo "#!/bin/sh" > /etc/service/nginx/run \
  && echo "exec 2>&1" >> /etc/service/nginx/run \
  && echo "exec /usr/sbin/nginx -g 'daemon off;'" >> /etc/service/nginx/run \
  && chmod +x /etc/service/nginx/run

# Create the 'run' script for PHP-FPM
RUN echo "#!/bin/sh" > /etc/service/php-fpm/run \
  && echo "exec 2>&1" >> /etc/service/php-fpm/run \
  && echo "exec /usr/sbin/php-fpm --nodaemonize" >> /etc/service/php-fpm/run \
  && chmod +x /etc/service/php-fpm/run

# Create the 'run' script for the queue processing
RUN echo "#!/bin/sh" > /etc/service/queue/run \
  && echo "exec chpst -u dockusr /usr/bin/php /app/runalyze/bin/console runalyze:queue:consume --env=prod --no-debug --stop-when-empty" >> /etc/service/queue/run \
  && chmod +x /etc/service/queue/run

# Add a cron job for queue processing
RUN echo "# runalyze batch/queue processing" >> /etc/cron.d/runalyzequeue \
  && echo "*/4 * * * * root sv start queue > /dev/null" >> /etc/cron.d/runalyzequeue \
  && chmod 600 /etc/cron.d/runalyzequeue

# Create the 'runit_init.sh' script
RUN echo '#!/bin/sh' > /usr/local/sbin/runit_init.sh \
  && echo '/usr/bin/runsvdir -P /etc/service' >> /usr/local/sbin/runit_init.sh \
  && chmod +x /usr/local/sbin/runit_init.sh


# nginx and php configuration
RUN phpdismod mysqli \
  # activate site and remove default
  #&& ln -s /etc/nginx/sites-available/nginxRunalyze /etc/nginx/sites-enabled/nginxRunalyze \
  #&& rm -r /etc/nginx/sites-enabled/default \
  # optimize nginx
  && sed -E -i 's|(^.*)#.*server_tokens.*;$|\1server_tokens off;|' 					/etc/nginx/nginx.conf \
  && sed -E -i 's|(^.*worker_processes\s+)(.*)(\s*;)$|\12\3|' 						/etc/nginx/nginx.conf \
  # symlink to start php without version
  && ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm \
  # aus irgendwelchen gruenden ist das verzeichnis nicht von anfang an da - hier also anlegen
  && mkdir -p /run/php/ \
  # ich habe es nicht vernuenftig hinbekommen, die dateien direkt ueber ein volume zu mounten
  && sed -E -i 's#^error_log\s+=.*$#error_log = /var/log/runalyze/php-fpm.log#' 		/etc/php/7.4/fpm/php-fpm.conf \
  && sed -E -i 's#^/var/log/php7.4-fpm.log#/var/log/runalyze/php-fpm.log#' 			/etc/logrotate.d/php7.4-fpm \
  && sed -E -i 's#^listen\s+=.*$#listen = /var/run/php/php-fpm.sock#' 				/etc/php/7.4/fpm/pool.d/www.conf \
  # optimierung php-fpm auf speicherverbrauch
  && sed -E -i 's#^pm\s+=.*$#pm = ondemand#' 											/etc/php/7.4/fpm/pool.d/www.conf \
  && sed -E -i 's#^;*pm.process_idle_timeout\s+=.*$#pm.process_idle_timeout = 25s#' 	/etc/php/7.4/fpm/pool.d/www.conf \
  # increase execition timeout (see also value in nginx config)
  && sed -E -i 's#^max_execution_time\s+=.*$#max_execution_time = 900#' 				/etc/php/7.4/fpm/php.ini \
  # set memory (128M is default)
  && sed -E -i 's#^memory_limit\s+=.*$#memory_limit = 128M#'			 				/etc/php/7.4/fpm/php.ini \
  # set file upload limits to 50 files
  && sed -E -i 's#^post_max_size\s+=.*$#post_max_size = 150M#'		 				/etc/php/7.4/fpm/php.ini \
  && sed -E -i 's#^upload_max_filesize\s+=.*$#upload_max_filesize = 30M#' 			/etc/php/7.4/fpm/php.ini \
  && sed -E -i 's#^max_file_uploads\s+=.*$#max_file_uploads = 50M#'	 				/etc/php/7.4/fpm/php.ini \
  # change to running user from www-data to dockusr
  && sed -E -i 's#^((user|group|listen\.owner|listen\.group)\s+=).*$#\1'$CONF_USER'#'	/etc/php/7.4/fpm/pool.d/www.conf \
  && sed -E -i 's|(^.*user\s+)(.*)(\s*;)$|\1'$CONF_USER'\3|' 							/etc/nginx/nginx.conf 
# change run user of queue start
#&& sed    -i 's#${RUN_USER}#'$CONF_USER'#' 											/etc/service/queue/run

# prepare runalyze
# Create a directory for the app
RUN mkdir -p $CONF_APP_ROOT && chown -R $CONF_USER:$CONF_USER $CONF_APP_ROOT




# Copy the entrypoint script into the image
COPY config/entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Create log files and set permissions
RUN mkdir -p /var/log/runalyze
RUN touch /var/log/runalyze/project_error.log /var/log/runalyze/project_access.log /var/log/runalyze/php-fpm.log
RUN chown $CONF_USER:$CONF_USER /var/log/runalyze/project_error.log /var/log/runalyze/project_access.log /var/log/runalyze/php-fpm.log
RUN chmod 664 /var/log/runalyze/project_error.log /var/log/runalyze/project_access.log /var/log/runalyze/php-fpm.log

RUN ln -sf /dev/stdout /var/log/runalyze/project_error.log && ln -sf /dev/stderr /var/log/runalyze/project_access.log && ln -sf /dev/stdout /var/log/runalyze/php-fpm.log

WORKDIR /app

USER $CONF_USER

# download runalyze and extract it (strip the root folder - it contains the branch name)
RUN echo "Downloading & extract..." \
  && mkdir -p $CONF_APP_ROOT \
  && curl -L -s https://github.com/codeproducer198/Runalyze/archive/master.zip | bsdtar --strip-components=1 -xf - -C $CONF_APP_ROOT --exclude "./tests"

# copy and protect the configuration file
USER root
COPY --chown=$CONF_USER:$CONF_USER --chmod="600" config/config.yml $CONF_APP_ROOT/data/config.yml



# Set the entry point to the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Start CMD using runit
CMD ["/usr/local/sbin/runit_init.sh"]

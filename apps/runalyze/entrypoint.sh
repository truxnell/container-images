#!/bin/bash

# Define the path to the config file
CONFIG_FILE="/app/runalyze/data/config.yml"

# Python script for replacing parameters with environment variables
python3 -c "$(
  cat <<EOF
import os

# Define the path to the config file
CONFIG_FILE = "/app/runalyze/data/config.yml"

# Function to replace a parameter if an environment variable exists
def replace_parameter(param_name, default_value):
    env_var_name = param_name.upper().replace(".", "_")
    value = os.environ.get(env_var_name, default_value)
    return f"  {param_name}: {value}"

# Define the parameters to replace and their default values
parameters_to_replace = {
    "locale": "en",
    "database_host": "127.0.0.1",
    "database_prefix": "runalyze_",
    "database_port": "3306",
    "database_name": "runalyze",
    "database_password": "test",
    "database_user": "runalyze_test",
    "secret": "please_change_this_secret",
    "update_disabled": "no",
    "user_can_register": "true",
    "user_disable_account_activation": "false",
    "maintenance": "false",
    "garmin_api_key": "",
    "weather_proxy": "",
    "openweathermap_api_key": "",
    "meteostatnet_api_key": "",
    "darksky_api_key": "",
    "nokia_here_appid": "",
    "nokia_here_token": "",
    "thunderforest_api_key": "",
    "mapbox_api_key": "",
    "geonames_username": "",
    "perl_path": "/usr/bin/perl",
    "python3_path": "/usr/bin/python3",
    "rsvg_path": "/usr/bin/rsvg-convert",
    "inkscape_path": "/usr/bin/inkscape",
    "ttbin_path": "../call/perl/ttbincnv",
    "sqlite_mod_spatialite": "libspatialite.so.5",
    "mail_sender": "",
    "mail_name": "",
    "smtp_host": "localhost",
    "smtp_port": "25",
    "smtp_security": "",
    "smtp_username": "",
    "smtp_password": "",
    "mail_localdomain": "",
    "backup_storage_period": "5",
    "poster_storage_period": "5",
    "router.request_context.host": "localhost",
    "router.request_context.scheme": "http",
    "router.request_context.base_url": "",
    "osm_overpass_url": "",
    "osm_overpass_proxy": ""
}

# Open the config file, replace parameters, and save the updated content
with open(CONFIG_FILE, "r") as f:
    config_lines = f.read().splitlines()

updated_config = []
for line in config_lines:
    for param, default in parameters_to_replace.items():
        if line.strip().startswith(f"{param}:"):
            updated_config.append(replace_parameter(param, default))
            break
    else:
        updated_config.append(line)

with open(CONFIG_FILE, "w") as f:
    f.write("\n".join(updated_config))

EOF
)"

# Start the cron service (queue processing)
sv start queue

# Start Apache in the foreground
exec "$@"

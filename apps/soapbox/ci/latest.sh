#!/usr/bin/env bash
version=$(curl -sX GET https://gitlab.com/api/v4/projects/soapbox-pub%2Fsoapbox/releases | jq --raw-output '.[0].name' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"

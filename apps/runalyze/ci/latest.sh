#!/usr/bin/env bash
version=$(curl -sX GET "https://api.github.com/repos/codeproducer198/Runalyze/commits" | jq --raw-output '.[0].commit.author.date' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"

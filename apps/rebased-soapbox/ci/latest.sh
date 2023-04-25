#!/usr/bin/env bash

rebased_commit_date=$(curl -sX GET "https://gitlab.com/api/v4/projects/soapbox%2Dpub%2Frebased/repository/commits?ref_name=develop&per_page=1" | jq -r ".[0].committed_date" 2>/dev/null)
soapbox_commit_date=$(curl -sX GET "https://gitlab.com/api/v4/projects/soapbox%2Dpub%2Fsoapbox/repository/commits?ref_name=develop&per_page=1" | jq -r ".[0].committed_date" 2>/dev/null)

# Compare commit dates and get the newest date
if [[ "${rebased_commit_date}" > "${soapbox_commit_date}" ]]; then
	newest_commit_date="${rebased_commit_date}"
else
	newest_commit_date="${soapbox_commit_date}"
fi

# Format the newest commit date as yyyy.mm.dd
formatted_commit_date=$(date -d "${newest_commit_date}" +%Y.%m.%d)

printf "%s" "${formatted_commit_date}"

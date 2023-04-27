#!/bin/bash

yt-dlp "$@"
exit_code=$?
echo "yt-dlp exit code $exit_code"
# Map the application exit code to appropriate exit code for Kubernetes
# Exit code 0 and 1 are mapped to 0 (success), and exit code 2 is mapped to 1 (warning)
case $exit_code in
0 | 1)
	k8s_exit_code=0 # success
	;;
2)
	k8s_exit_code=1 # warning
	;;
*)
	k8s_exit_code=2 # failure
	;;
esac
echo "returnign k8s_exit code $k8s_exit_code"
# Exit with the mapped exit code for Kubernetes
exit $k8s_exit_code

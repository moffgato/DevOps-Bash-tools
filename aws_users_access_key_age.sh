#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2019-12-05 17:02:15 +0000 (Thu, 05 Dec 2019)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# Quick script to dump all users access key status and age
#
# See also:
#
# aws_users_access_key_age_report.sh - much quicker version for lots of users
#
# aws_users_access_key_age.py in DevOps Python Tools which is able to filter by age and status
#
# https://github.com/harisekhon/devops-python-tools
#
# awless list accesskeys --format tsv | grep 'years[[:space:]]*$'

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

echo "output will be formatted in to columns at end" >&2
echo "getting user list" >&2
aws iam list-users |
jq -r '.Users[].UserName' |
while read -r username; do
    echo "querying user $username" >&2
    aws iam list-access-keys --user-name "$username" |
    jq -r '.AccessKeyMetadata[] | [.UserName, .Status, .CreateDate, .AccessKeyId] | @tsv'
done |
column -t

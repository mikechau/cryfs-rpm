#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

mkdir -p "${DIST_DIR}"
chown $USER_ID:$USER_ID -R "${DIST_DIR}"

/usr/local/bin/gosu user bash -c 'git config --global user.email "user@localhost"'
/usr/local/bin/gosu user bash -c 'git config --global user.name "User"'

exec /usr/local/bin/gosu user "$@"

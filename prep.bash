#!/usr/bin/env bash

set -euo pipefail

mkdir --parents "${DOCKER_APP_DATA_DIR}"

# backrest
readonly restic_backup_dir='/backups/restic'
sudo mkdir --parents "${restic_backup_dir}"
sudo chown --recursive "${USER}:" "${restic_backup_dir}"

# filebrowser
mkdir --parents "${DOCKER_APP_DATA_DIR}/filebrowser"
touch "${DOCKER_APP_DATA_DIR}/filebrowser/filebrowser.db"

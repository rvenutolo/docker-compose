#!/usr/bin/env bash

set -euo pipefail

# backrest
readonly restic_backup_dir='/backups/restic'
sudo mkdir --parents "${restic_backup_dir}"
sudo chown --recursive "${USER}:" "${restic_backup_dir}"

# filebrowser
touch "${DOCKER_APP_DATA_DIR:?}/filebrowser/filebrowser.db"

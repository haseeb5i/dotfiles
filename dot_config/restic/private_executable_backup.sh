#!/bin/bash
# nightly homelab backup to backblaze b2, run by restic-backup.service
set -euo pipefail
secret() { podman secret inspect --showsecret --format '{{.SecretData}}' "$1"; }
export AWS_ACCESS_KEY_ID=$(secret b2_key_id) AWS_SECRET_ACCESS_KEY=$(secret b2_app_key) RESTIC_PASSWORD=$(secret restic_password)
export RESTIC_REPOSITORY=s3:https://s3.eu-central-003.backblazeb2.com/haseeb5i-homelab/pc
S=$HOME/.local/share

# a running postgres can't be copied file by file, so dump it instead
mkdir -p -m 700 $S/backup-dumps
podman exec blinko-postgres pg_dumpall -U postgres > $S/backup-dumps/blinko.sql
podman exec adventurelog-db pg_dumpall -U adventure > $S/backup-dumps/adventurelog.sql

# sqlite and pglite apps are stopped while restic reads them, so their files are consistent
STOP="authelia actual mealie freshrss activepieces"
trap 'systemctl --user start $STOP' EXIT
systemctl --user stop $STOP
# configs live in chezmoi; users.yml stays here because it holds the password hash
# unshare runs restic as the container users, so it can read files they own
podman unshare restic backup --quiet \
  --exclude "$S/*/postgres" --exclude "$S/activepieces/cache" \
  $S/{backup-dumps,authelia,authelia-valkey,caddy,actual,mealie,freshrss,blinko,adventurelog,activepieces} \
  $HOME/.config/authelia/users.yml
systemctl --user start $STOP
trap - EXIT

podman unshare restic forget --quiet --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

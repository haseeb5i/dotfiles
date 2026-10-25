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
podman exec immich-postgres pg_dumpall -U postgres > $S/backup-dumps/immich.sql
podman exec hindsight-postgres pg_dumpall -U hindsight > $S/backup-dumps/hindsight.sql

# sqlite and pglite apps are stopped while restic reads them, so their files are consistent
STOP="authelia actual mealie freshrss activepieces deeptutor"
trap 'systemctl --user start $STOP' EXIT
systemctl --user stop $STOP
# configs live in chezmoi; users.yml and the podman secrets stay here because they hold passwords and keys
# unshare runs restic as the container users, so it can read files they own
podman unshare restic backup --quiet \
  --exclude "$S/*/postgres" --exclude "$S/activepieces/cache" --exclude "$S/immich/model-cache" \
  $S/{backup-dumps,authelia,authelia-valkey,caddy,actual,mealie,freshrss,blinko,adventurelog,activepieces,immich,deeptutor,hindsight} \
  $HOME/.config/authelia/users.yml $HOME/.local/share/containers/storage/secrets
systemctl --user start $STOP
trap - EXIT

podman unshare restic forget --quiet --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

# on sundays also re-read a random 5% of the stored data, so a damaged repo shows up before a restore needs it
if [ "$(date +%u)" = 7 ]; then
  podman unshare restic check --read-data-subset=5%
fi

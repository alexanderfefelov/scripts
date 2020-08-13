#!/usr/bin/env bash

#
# Prerequisites:
#
# 1. Install mydumper (https://github.com/maxbube/mydumper)
#
# 2. Install rotate-backups:
#
#         pip install rotate-backups
#
# 3. Install wait-for-it (https://github.com/vishnubob/wait-for-it)
#
# 4. Create the MySQL account with required permissions:
#
#         CREATE USER 'backup_letocryloite'@'%' IDENTIFIED WITH mysql_native_password BY 'almatramushi';
#         GRANT EVENT, LOCK TABLES, PROCESS, RELOAD, REPLICATION CLIENT, SELECT, SHOW VIEW, TRIGGER ON *.* TO 'backup_letocryloite'@'%';
#

readonly SOFTWARE=mydumper # https://github.com/maxbube/mydumper

readonly HOME=$(dirname "$(realpath "$0")")

. $HOME/settings-common.sh
. $HOME/settings-mydumper.sh
. $HOME/functions.sh

make_local_backup() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  mydumper \
    --host $DB_HOST --port $DB_PORT --user $DB_USERNAME --password $DB_PASSWORD --database $DB_DATABASE \
    \
    --build-empty-files \
    --compress \
    --events \
    --lock-all-tables \
    --logfile $LOCAL_TMP_OUTPUT_DIR/backup.log \
    --outputdir $LOCAL_TMP_OUTPUT_DIR \
    --routines \
    --threads $THREADS \
    --triggers
  if [ $? -ne 0 ]; then
    log_error "$TASK failed: $(< $LOCAL_TMP_OUTPUT_DIR/backup.log)"
    return 1
  fi

  log_notice "$TASK finished"
}

execute

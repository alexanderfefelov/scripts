#!/usr/bin/env bash

#
# Prerequisites:
#
# 1. Install client for MySQL:
#
#         Debian:
#
#                 apt install default-mysql-client
#
#         Ubuntu:
#
#                 apt install mysql-client
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

readonly SOFTWARE=mysqldump # https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html

readonly HOME=$(dirname "$(realpath "$0")")

. $HOME/settings-common.sh
. $HOME/settings-mysqldump.sh
. $HOME/functions.sh

make_local_backup() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  mysqldump \
    --host=$DB_HOST --port=$DB_PORT --user=$DB_USERNAME --password=$DB_PASSWORD \
    \
    --allow-keywords \
    --column-statistics=0 \
    --disable-keys \
    --events \
    --flush-logs \
    --hex-blob \
    --master-data \
    --result-file=$LOCAL_TMP_OUTPUT_DIR/$DB_DATABASE.sql \
    --routines \
    --single-transaction \
    --triggers \
    $DB_DATABASE
  if [ $? -ne 0 ]; then
    log_error "$TASK failed"
    return 1
  fi

  log_notice "$TASK finished"
}

execute

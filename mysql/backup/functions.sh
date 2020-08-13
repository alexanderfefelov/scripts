log_notice() {
  local -r MESSAGE="[$BASHPID] $SCRIPT ($ORIGIN): $@"
  echo $MESSAGE
  $LOGGER --priority $LOGGER_PRIORITY_NOTICE $MESSAGE
}

log_error() {
  local -r MESSAGE="[$BASHPID] $SCRIPT ($ORIGIN): $@"
  echo $MESSAGE >&2
  $LOGGER --priority $LOGGER_PRIORITY_ERROR $MESSAGE
}

check_database_port() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  wait-for-it.sh --quiet --host=$DB_HOST --port=$DB_PORT --timeout=3
  if [ $? -ne 0 ]; then
    log_error "$TASK failed"
    return 1
  fi

  log_notice "$TASK finished"
}

prepare_for_backup() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  mkdir --parents $LOCAL_TMP_OUTPUT_DIR
  if [ $? -ne 0 ]; then
    log_error "$TASK failed"
    return 1
  fi

  log_notice "$TASK finished"
}

create_archive() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  (cd $LOCAL_BACKUP_DIR && tar --create --gzip --file $LOCAL_ARCHIVE_FILE $LOCAL_TMP_OUTPUT_DIR_LAST_ELEM)
  if [ $? -ne 0 ]; then
    log_error "$TASK failed"
    return 1
  fi

  log_notice "$TASK finished"
}

verify_archive() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  gzip --test $LOCAL_ARCHIVE_FILE
  if [ $? -ne 0 ]; then
    log_error "$TASK failed"
    return 1
  fi

  log_notice "$TASK finished"
}

clear_stuff() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  rm --recursive --force $LOCAL_TMP_OUTPUT_DIR
  if [ $? -ne 0 ]; then
    log_error "$TASK failed"
    return 1
  fi

  log_notice "$TASK finished"
}

rotate_local_backups() {
  local -r TASK=${FUNCNAME[0]}
  log_notice "$TASK started"

  rotate-backups \
    --syslog=no \
    --relaxed \
    --hourly="$LOCAL_KEEP_HOURLY" \
    --daily="$LOCAL_KEEP_DAILY" \
    --weekly="$LOCAL_KEEP_WEEKLY" \
    --monthly="$LOCAL_KEEP_MONTHLY" \
    --yearly="$LOCAL_KEEP_YEARLY" \
    $LOCAL_BACKUP_DIR
  if [ $? -ne 0 ]; then
    log_error "$TASK failed"
    return 1
  fi

  log_notice "$TASK finished"
}

execute() {
  log_notice "started"  \
  && check_database_port \
  && prepare_for_backup \
  && make_local_backup \
  && create_archive \
  && verify_archive \
  && clear_stuff \
  && rotate_local_backups \
  && log_notice "finished"
}

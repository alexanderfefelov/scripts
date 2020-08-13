readonly SCRIPT=$(basename "$0")
readonly ORIGIN=$1

readonly STARTED_AT=$(date +%Y%m%d_%H%M%S)

# Database connection
#
readonly DB_HOST=${DB_HOST:-mysql.test}
readonly DB_PORT=${DB_PORT:-3306}
readonly DB_USERNAME=${DB_USERNAME:-backup_letocryloite}
readonly DB_PASSWORD=${DB_PASSWORD:-almatramushi}
readonly DB_DATABASE=$ORIGIN

# Local backup
#
readonly LOCAL_BACKUP_HOME=${LOCAL_BACKUP_HOME:-$HOME/var/mysql/backup}
readonly LOCAL_BACKUP_DIR=$LOCAL_BACKUP_HOME/db/$DB_DATABASE
readonly LOCAL_ARCHIVE_FILE=$LOCAL_BACKUP_DIR/${DB_HOST}_${DB_DATABASE}_${STARTED_AT}.$SOFTWARE.tgz
readonly LOCAL_TMP_OUTPUT_DIR_LAST_ELEM=$STARTED_AT.$SOFTWARE
readonly LOCAL_TMP_OUTPUT_DIR=$LOCAL_BACKUP_DIR/$LOCAL_TMP_OUTPUT_DIR_LAST_ELEM

# Local rotation policy
#
readonly LOCAL_KEEP_HOURLY=${LOCAL_KEEP_HOURLY:-24}
readonly LOCAL_KEEP_DAILY=${LOCAL_KEEP_DAILY:-7}
readonly LOCAL_KEEP_WEEKLY=${LOCAL_KEEP_WEEKLY:-5}
readonly LOCAL_KEEP_MONTHLY=${LOCAL_KEEP_MONTHLY:-12}
readonly LOCAL_KEEP_YEARLY=${LOCAL_KEEP_YEARLY:-always}

# Logging priorities
#
readonly LOGGER_PRIORITY_NOTICE=${LOGGER_PRIORITY_NOTICE:-user.notice}
readonly LOGGER_PRIORITY_ERROR=${LOGGER_PRIORITY_ERROR:-user.error}

# Remote syslog settings
#
readonly LOGGER_SYSLOG_HOST=${LOGGER_SYSLOG_HOST:-syslog.test}
readonly LOGGER_SYSLOG_PORT=${LOGGER_SYSLOG_PORT:-514}

# Predefined loggers
#
readonly LOGGER_IMPL_NO_OP=:
readonly LOGGER_IMPL_SYSLOG=logger
readonly LOGGER_IMPL_REMOTE_SYSLOG="logger --server $LOGGER_SYSLOG_HOST --port $LOGGER_SYSLOG_PORT --udp --rfc3164"

# Logging
#
readonly LOGGER=${LOGGER:-$LOGGER_IMPL_REMOTE_SYSLOG}

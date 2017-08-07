#!/bin/bash

# redirect normal output to a logfile
LOGFILE="/var/log/backup.log"
exec >> $LOGFILE

echo "$0 - $(date +"%F %T") daily backup started"

BACKUP_PATH="/data/backups/company/daily"
COMPANY_PATH="/data/company"
CUT_OFF_DATE="$(date +"%F 00:00:00" --date='-1 month -1 day')"

#TODO move this out of here
rsync -a /data/mnt/diskstation/dev-server/nginx/user_share_nginx/html/accounts/ /data/company/ONLINE/

mkdir -p "${BACKUP_PATH}"

EXCLUDE=""
for YEAR in $(seq 2012 $(date +%Y)); do
    if [ -e "${COMPANY_PATH}/${YEAR}" ]
    then
        EXCLUDE="${EXCLUDE} --exclude ${YEAR}"
        if [[ -n $(find "${COMPANY_PATH}/${YEAR}" -type f -newermt "${CUT_OFF_DATE}") ]]
        then
          BACKUP_FILE="${BACKUP_PATH}/$(date +%Y-%m-%d)-Company-${YEAR}.tar.gz"
          echo "$0 - $(date +"%F %T") Backing up [${COMPANY_PATH}/${YEAR}] to [${BACKUP_FILE}]"
          tar -C "${COMPANY_PATH}" -zcf "${BACKUP_FILE}" "${YEAR}"

          # keep only last 7 backups
          (ls -t "${BACKUP_PATH}}"/*-Company-${YEAR}.*| awk 'NR>7')|xargs -r rm
        else
          echo "$0 - $(date +"%F %T") NOT Backing up [${COMPANY_PATH}/${YEAR}]. No changes found since [${CUT_OFF_DATE}]"
        fi
        # keep only last 7 backups
        (ls -t "${BACKUP_PATH}"/*-Company-${YEAR}.*| awk 'NR>7')|xargs -r rm
    fi
done

BACKUP_FILE="${BACKUP_PATH}/$(date +%Y-%m-%d)-Company-Other.tar.gz"
echo "$0 - $(date +"%F %T") Backing up rest of files in [${COMPANY_PATH}] to [${BACKUP_FILE}]"
tar -C "${COMPANY_PATH}" -zcf "${BACKUP_FILE}" ${EXCLUDE} "."

# keep only last 7 backups
(ls -t "${BACKUP_PATH}"/*-Company-Other.*| awk 'NR>7')|xargs -r rm

echo "$0 - $(date +"%F %T") daily backup finished"

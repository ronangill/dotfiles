#!/bin/bash

echo "$0 - $(date +"%F %T") daily backup started"

BACKUP_PATH="/data/backups/company/daily"
COMPANY_PATH="/data/company"

#TODO move this out of here
rsync -a /data/mnt/diskstation/dev-server/nginx/user_share_nginx/html/accounts/ /data/company/ONLINE/

if [ ! -e "${BACKUP_PATH}" ]
then
    mkdir -p ${BACKUP_PATH}
fi

EXCLUDE=""
for YEAR in $(seq 2013 $(date +%Y)); do
    if [ -e "${COMPANY_PATH}/${YEAR}" ]
    then
        BACKUP_FILE="${BACKUP_PATH}/$(date +%Y-%m-%d)-Company-${YEAR}.tar.gz"
        echo "$0 - $(date +"%F %T") Backing up [${COMPANY_PATH}/${YEAR}] to [${BACKUP_FILE}]"
        tar -C "${COMPANY_PATH}" -zcf "${BACKUP_FILE}" "${YEAR}"
        EXCLUDE="${EXCLUDE} --exclude ${YEAR}"
        (ls -t /data/backups/company/daily/*-Company-${YEAR}.*| awk 'NR>14')|xargs -r rm
    fi
done

BACKUP_FILE="${BACKUP_PATH}/$(date +%Y-%m-%d)-Company-Other.tar.gz"
echo "$0 - $(date +"%F %T") Backing up rest of files in [${COMPANY_PATH}] to [${BACKUP_FILE}]"
tar -C "${COMPANY_PATH}" -zcf "${BACKUP_FILE}" ${EXCLUDE} "."

# Remove files older that 2 weeks
(ls -t /data/backups/company/daily/*-Company-Other.*| awk 'NR>14')|xargs -r rm

echo "$0 - $(date +"%F %T") daily backup finished"

#!/bin/bash

echo "$0 - $(date +"%F %T") monthly backup started"

BACKUP_PATH="/data/backups/company/monthly"
COMPANY_PATH="/data/company"

if [ ! -e "${BACKUP_PATH}" ]
then
    mkdir -p ${BACKUP_PATH}
fi

EXCLUDE=""
for YEAR in $(seq 2007 $(date +%Y)); do
    if [ -e "${COMPANY_PATH}/${YEAR}" ]
    then
        BACKUP_FILE="${BACKUP_PATH}/$(date +%Y-%m)-Company-${YEAR}.tar.gz"
        echo "$0 - $(date +"%F %T") Backing up [${COMPANY_PATH}/${YEAR}] to [${BACKUP_FILE}]"
        tar -C "${COMPANY_PATH}" -zcf "${BACKUP_FILE}" "${YEAR}"
        EXCLUDE="${EXCLUDE} --exclude ${YEAR}"
        # Remove files older that 6 months
        (ls -t /data/backups/company/monthly/*-Company-${YEAR}.*| awk 'NR>6')|xargs -r rm
    fi
done

BACKUP_FILE="${BACKUP_PATH}/$(date +%Y-%m)-Company-Other.tar.gz"
echo "$0 - $(date +"%F %T") Backing up rest of files in [${COMPANY_PATH}] to [${BACKUP_FILE}]"
tar -C "${COMPANY_PATH}" -zcf "${BACKUP_FILE}" ${EXCLUDE} "."

# Remove files older that 6 months
(ls -t /data/backups/company/monthly/*-Company-Other.*| awk 'NR>6')|xargs -r rm

echo "$0 - $(date +"%F %T") monthly backup finished"


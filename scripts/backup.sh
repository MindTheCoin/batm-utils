#!/bin/bash
set -eu

OLD_BACKUP=$(date --date '15 days ago' '+%Y%m%d')
EVEN_OLDER_BACKUP=$(date --date '20 days ago' '+%Y%m%d')
CURRENT_BACKUP=$(date '+%Y%m%d')
BACKUP_DIR="/extra/batm/backup"
S3_BUCKET="YOUR_S3_BUCKET_HERE"

rm -fr $BACKUP_DIR/$OLD_BACKUP-*
/batm/batm-manage stop all
sleep 15
/batm/batm-manage backup
sleep 5 
/batm/batm-manage start all
setfacl -R -m u:ubuntu:rx $BACKUP_DIR

## copy current backup to s3
aws s3 cp $BACKUP_DIR/$CURRENT_BACKUP-* s3://$S3_BUCKET/$CURRENT_BACKUP --recursive
aws s3 rm s3://$S3_BUCKET/$EVEN_OLDER_BACKUP --recursive

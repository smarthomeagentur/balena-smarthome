#! /bin/bash

echo "---Backup Started---" >/proc/1/fd/1

mapfile -t config < <( cat /usr/src/app/config)
RESIN_DEVICE_UUID=$(echo ${config[0]})
FILE_LIMIT=$(echo ${config[1]})
BALENA_APP_NAME=$(echo ${config[2]})
BALENA_DEVICE_NAME_AT_INIT=$(echo ${config[3]})
GDRIVE_FOLDER_ID=$(echo ${config[4]})

mkdir /usr/src/app/sync || true
mkdir /usr/src/app/sync/$RESIN_DEVICE_UUID\_$BALENA_APP_NAME || true
tar -cvjf /usr/src/app/sync/$RESIN_DEVICE_UUID\_$BALENA_APP_NAME/$RESIN_DEVICE_UUID\_$(date +%Y-%m-%d_%H:%M:%S)\_$BALENA_APP_NAME\_$BALENA_DEVICE_NAME_AT_INIT.tar.bz2 /usr/src/app/backup/
gdrive sync upload --keep-remote /usr/src/app/sync/ $GDRIVE_FOLDER_ID
rm -r /usr/src/app/sync

maxcount_files=$FILE_LIMIT
device_uuid=$(echo ${RESIN_DEVICE_UUID::-8})
mapfile -t backup_files < <( gdrive list --query "name contains '$device_uuid'" --order modifiedTime | grep "bin")
my_array_length=${#backup_files[@]}
echo "$my_array_length Backup Files" >/proc/1/fd/1
echo "Limit is $maxcount_files" >/proc/1/fd/1
if (( my_array_length > maxcount_files )) && (( maxcount_files >= 1 )) && [[ ! -z "$device_uuid" ]]; then
    to_delete=$((my_array_length - maxcount_files))
    echo "$to_delete Files Removed" >/proc/1/fd/1
    count=0
    while (( $count < $to_delete )); do
        file_delete=$(echo ${backup_files[count]} | awk '{print $1;}')
        echo "Remove File with ID $file_delete" >/proc/1/fd/1
        gdrive delete $file_delete
        count=$((count + 1))
    done
fi
echo "---Backup Done---" >/proc/1/fd/1

#END
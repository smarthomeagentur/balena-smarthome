#! /bin/bash
#START
mkdir /usr/src/app/sync || true
mkdir /usr/src/app/sync/$RESIN_DEVICE_UUID\_$BALENA_APP_NAME || true
tar -cvjf /usr/src/app/sync/$RESIN_DEVICE_UUID\_$BALENA_APP_NAME/$RESIN_DEVICE_UUID\_$(date +%Y-%m)\_$BALENA_APP_NAME\_$BALENA_DEVICE_NAME_AT_INIT.tar.bz2 /usr/src/app/backup/
gdrive sync upload --keep-remote /usr/src/app/sync/ $GDRIVE_FOLDER_ID
rm -r /usr/src/app/sync

maxcount_files=$FILE_LIMIT
device_uuid=${RESIN_DEVICE_UUID::-8}
mapfile -t backup_files < <( gdrive list --query "name contains '$device_uuid'" --order modifiedTime | grep "bin")
my_array_length=${#backup_files[@]}
echo "$my_array_length Backup Files"
echo "Limit is $maxcount_files"
if (( my_array_length > maxcount_files )); then
    to_delete=$((my_array_length - maxcount_files))
    echo "$to_delete Files Removed"
    count=0
    while (( $count < $to_delete )); do
        file_delete=$(echo ${backup_files[count]} | awk '{print $1;}')
        echo "Remove File with ID $file_delete"
        gdrive delete $file_delete
        count=$((count + 1))
    done
fi
#END
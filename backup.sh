#!/bin/bash

# Define variables
CONTAINER_NAME="minecraft-java-server"
BACKUP_DIR="/media/samy/verbatim/backup/${CONTAINER_NAME}"
TEMP_DIR="/tmp/${CONTAINER_NAME}"
NFS_SHARE="fileserver:/path/to/nfs/share"
NFS_MOUNT_POINT="/mnt/nfs"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/minecraft_world_backup_${DATE}.tar.gz"
RETENTION_DAYS=7

# Copy the world directory from the container to the host
echo "Copying world directory from container to host..."
docker cp ${CONTAINER_NAME}:/data/world ${TEMP_DIR}

# Create a backup of the world directory
echo "Creating backup..."
if tar -czf ${BACKUP_FILE} -C ${TEMP_DIR} world; then
    echo "Backup completed: ${BACKUP_FILE}"

    # Mount the NFS share
    echo "Mounting NFS share..."
    mkdir -p ${NFS_MOUNT_POINT}
    mount ${NFS_SHARE} ${NFS_MOUNT_POINT}

    if [ $? -eq 0 ]; then
        # Copy the backup to the NFS share
        echo "Copying backup to NFS share..."
        cp ${BACKUP_FILE} ${NFS_MOUNT_POINT}/

        # Unmount the NFS share
        echo "Unmounting NFS share..."
        umount ${NFS_MOUNT_POINT}

        # Delete old backups
        find ${BACKUP_DIR} -name "minecraft_world_backup_*.tar.gz" -mtime +${RETENTION_DAYS} -exec rm {} \;
    else
        echo "Failed to mount NFS share!"
    fi
else
    echo "Backup failed!"
fi

# Clean up temporary directory
rm -rf ${TEMP_DIR}/world

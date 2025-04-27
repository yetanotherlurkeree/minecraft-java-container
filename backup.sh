#!/bin/bash

# Define variables
CONTAINER_NAME="minecraft-java-server"
BACKUP_DIR="/media/samy/verbatim/backup/${CONTAINER_NAME}"
TEMP_DIR="/media/samy/verbatim/project/minecraft-java/minecraft"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/minecraft_world_backup_${DATE}.tar.gz"
RETENTION_DAYS=7

# Copy the whole minecraft folder including worlds and server settings
echo "Copying minecraft server folder from container..."
docker cp ${CONTAINER_NAME}:/data/minecraft/world ${TEMP_DIR}

# Create a backup 
echo "Creating backup..."
if tar -czf ${BACKUP_FILE} -C ${TEMP_DIR} minecraft; then
    echo "Backup completed: ${BACKUP_FILE}"

    # Delete old backups
    find ${BACKUP_DIR} -name "minecraft_world_backup_*.tar.gz" -mtime +${RETENTION_DAYS} -exec rm {} \;
else
    echo "Backup failed!"
fi

# copy 

# Clean up temporary directory
#rm -rf ${TEMP_DIR}/world


echo "Defining variables..."
# Define variables
CONTAINER_NAME="minecraft-java-server"
BACKUP_DIR="/media/verbatim/samy/backup/${CONTAINER_NAME}"
TEMP_DIR="/media/verbatim/samy/project/minecraft-java/backup/"
LAST_BACKUP_LINK="${TEMP_DIR}latest_backup"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/minecraft_world_backup_${DATE}.tar.gz"
RETENTION_DAYS=7

# Copy the whole minecraft folder including worlds and server settings
echo "Copying minecraft server folder from container..."
docker cp ${CONTAINER_NAME}:/data/minecraft ${TEMP_DIR}

# Create a backup 
echo "Creating backup..."
if tar -czf ${BACKUP_FILE} -C ${TEMP_DIR} minecraft; then
    echo "Backup completed: ${BACKUP_FILE}"

    # Delete old backups
    find ${BACKUP_DIR} -name "minecraft_world_backup_*.tar.gz" -mtime +${RETENTION_DAYS} -exec rm {} \;

    # Update the latest backup link
    rm ${LAST_BACKUP_LINK}
    ln -s ${BACKUP_FILE} ${LAST_BACKUP_LINK}
else
    echo "Backup failed!"
fi

# copy 

# Clean up temporary directory
#rm -rf ${TEMP_DIR}/world

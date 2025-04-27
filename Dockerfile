# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Set the timezone to UTC (or your preferred timezone)
ENV TZ=UTC
# Configure the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary dependencies and OpenJDK 21
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-21-jdk-headless \
    tar \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create all the required folders
RUN mkdir /data
RUN mkdir /data/minecraft
RUN mkdir /data/git
RUN mkdir /data/last-backup

# Get the latest worlds from the backup
WORKDIR /data/last-backup
COPY ./last_backup.tar.gz /data/last-backup/last_backup.tar.gz
RUN tar -xzvf /data/last-backup/last_backup.tar.gz
RUN mv /data/last-backup/minecraft/world* /data/minecraft

# Get the latest config from git
WORKDIR /data/git
RUN git clone https://github.com/yetanotherlurkeree/minecraft-java-container.git
RUN ls /data/git/minecraft-java-container/backup
RUN cp -r /data/git/minecraft-java-container/backup/minecraft/* /data/minecraft

# Get the paper server for minecraft
RUN wget -O /data/minecraft/server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/226/downloads/paper-1.21.4-226.jar

# Accept the EULA
RUN echo "eula=true" > /data/minecraft/eula.txt

# Expose the default Minecraft server port
EXPOSE 25565

# Command to run the server
WORKDIR /data/minecraft
CMD ["java", "-Xms1024M", "-Xmx2048M", "-jar", "server.jar", "nogui"]

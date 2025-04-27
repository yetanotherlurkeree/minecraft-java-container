# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Install necessary dependencies and OpenJDK 21
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /data

# Copy the local Minecraft backup archive into the container
COPY minecraft.tar.gz /data/

RUN ls -l /data/minecraft.tar.gz

# Extract the backup archive
RUN tar -xzvf /data/minecraft.tar.gz 
RUN chown -R root:root /data/minecraft/*

RUN ls -l /data/minecraft/server.jar

# Copy the latest server.jar into the container
#COPY server.jar /data/minecraft/minecraft_server.jar

# Set permissions for the .jar file
#RUN chmod 644 minecraft_server.jar

# Verify the minecraft_server.jar file exists and has the correct permissions
#RUN ls -l /data

# Verify Java installation
#RUN java -version

# Accept the EULA
RUN echo "eula=true" > /data/minecraft/eula.txt

#RUN ls -l /data

# Expose the default Minecraft server port
EXPOSE 25565

# Command to run the server
#RUN java -Xms1G -Xmx1G -jar /data/minecraft/server.jar nogui 
WORKDIR /data/minecraft
CMD ["sh", "-c", "ls -l /data/minecraft && cat /data/minecraft/eula.txt && java -Xms1G -Xmx1G -jar /data/minecraft/server.jar nogui"]

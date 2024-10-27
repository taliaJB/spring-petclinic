# This dockerfile sets up Jenkins master for petclinic project;
FROM openjdk:19-jdk-alpine3.16

# Env variables;
ARG JENKINS_HOME="/home/user"
ENV JENKINS_HOST="localhost"
ENV JENKINS_PASS="pass"
ENV JENKINS_PORT=8080
ENV JENKINS_USER="user"

# Set workdir;
WORKDIR /mysetupapp

# Install additional packages required for the script / agent build jobs;
RUN apk --no-cache add curl

# Copy required configuration;
COPY petclinic-credentials.xml .
COPY petclinic-job.xml .
COPY setupJenkins.sh .
RUN chmod +x setupJenkins.sh

# Deinfe user other than root;
RUN addgroup -S setupgroup && adduser -S setupuser -G setupgroup
RUN chown -R setupuser:setupgroup . 
USER setupuser

# Run the agent command;
CMD ["./setupJenkins.sh"]

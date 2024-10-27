# Docker file to create a jenkins node;
# Using root user to access volume for host docker;
FROM openjdk:19-jdk-alpine3.16

# Env variables;
ARG JENKINS_HOME="/home/user"
ENV JENKINS_HOST="localhost"
ENV JENKINS_PASS="pass"
ENV JENKINS_PORT=8080
ENV JENKINS_USER="user"
ENV LOG_SUCCESS="success.txt"
ENV NODE_NAME="my_node"

# Update Alpine Linux Package Manager and Install the bash and curl to run the script;
#RUN apk update && apk add bash
# Install additional packages required for the script / agent build jobs;
RUN apk update
RUN apk --no-cache add curl
RUN apk add git
RUN apk add --no-cache docker-cli

# Set work dir;
WORKDIR $JENKINS_HOME

# Copy node.xml;
COPY node.xml .

# Copy script to run;
COPY setupAgent.sh .
RUN chmod +x setupAgent.sh

# Run the agent command;
CMD ["./setupAgent.sh"]

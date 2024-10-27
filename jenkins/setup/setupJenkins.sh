#!/bin/sh
# This script logs to existing Jenkins master via Jenkins CLI jar and sets up specific credentials and job;

# Variables;
ADMIN="$JENKINS_USER:$JENKINS_PASS"
CMD_JENKINS="java -jar $JAR_CLI -s $URL_JENKINS -auth $ADMIN"
URL_JENKINS="${JENKINS_PROTOCOL}://$JENKINS_HOST:$JENKINS_PORT"

function log_exit()
{
  printf '%s\n' "$1" >&2
  exit 1
}

# Get Jenkins jar;
[ ! -e $JAR_CLI ] && curl $URL_JENKINS$JENKINS_JAR_PATH$JAR_CLI --output $JAR_CLI
[ -e $JAR_CLI ] || log_exit "Failed to fetch Jenkins CLI jar"

# Add credentials;
java -jar $JAR_CLI -s $URL_JENKINS -auth $ADMIN create-credentials-by-xml system::system::jenkins _ < petclinic-credentials.xml
[ $? -eq 0 ] || log_exit "Failed to add credentials"

# Create job for pipeline;
java -jar $JAR_CLI -s $URL_JENKINS -auth $ADMIN create-job "$JOB_NAME" < petclinic-job.xml
[ $? -eq 0 ] || log_exit "Failed to create pipeline"

# Log success;
echo "Successfully completed setting up Jenkins" 2>&1 | tee $LOG_SUCCESS

# List of plugins: https://updates.jenkins.io/download/plugins/
# Plugin: 
# cloudbees-credentials  -      required for being able to create credentials;
# docker-build-publish   -      required for using docker;
# github-branch-source   -      required for using git in pipeline;
# ssh-slaves             -      provides a means to launch agents via SSH;
# workflow-aggregator    -       requred for creating pipeline jobs;

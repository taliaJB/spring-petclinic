#!/bin/sh
# This script creates a node on the jenkins server and runs it;

# Variables;
ADMIN="$JENKINS_USER:$JENKINS_PASS"
URL_JENKINS="${JENKINS_PROTOCOL}://$JENKINS_HOST:$JENKINS_PORT"
SECRET_FILE="secret-file"

function log_exit()
{
  printf '%s\n' "$1" >&2
  exit 1
}

# Get agent jar;
[ ! -e $JAR_AGENT ] && curl -sO $URL_JENKINS$JENKINS_JAR_PATH$JAR_AGENT
[ -e $JAR_AGENT ] || log_exit "Failed to fetch Jenkins Agent jar"

# Get Jenkins jar;
[ ! -e $JAR_CLI ] && curl $URL_JENKINS$JENKINS_JAR_PATH$JAR_CLI --output $JAR_CLI
[ -e $JAR_CLI ] || log_exit "Failed to fetch Jenkins CLI jar"

# Set and create node;
sed -i -e "s#MY_NODE_NAME#${NODE_NAME}#g" -e "s#JENKINS_HOME#${JENKINS_HOME}#g" node.xml
java -jar $JAR_CLI -s $URL_JENKINS -auth $ADMIN create-node < node.xml
[ -n $(java -jar $JAR_CLI -s $URL_JENKINS -auth $ADMIN get-node "$NODE_NAME" | grep -q "$NODE_NAME" ) ] || log_exit "Failed to create node"

# Get node secret;
echo $(echo "println jenkins.model.Jenkins.instance.nodesObject.getNode('$NODE_NAME')?.computer?.jnlpMac" | java -jar $JAR_CLI -s $URL_JENKINS -auth $ADMIN groovy = ) > "$SECRET_FILE"
[ -e "$SECRET_FILE" ] && [ $(wc -m "$SECRET_FILE" | awk '{print $1}') -gt 1 ] || log_exit "Failed to fetch agent secret"

# Run the agent;
java -jar $JAR_AGENT -url "$URL_JENKINS" -secret @secret-file -name "$NODE_NAME" -webSocket -workDir "$HOME" && echo "Status: Completed" > status.txt &
current_processes=$(ps -ef)
[ $( ps -ef | grep -o "java -jar $JAR_AGENT" | wc -l ) -gt 1 ] || log_exit "Failed to run the agent"

# Log success;
echo "Successfully started Jenkins Agent" >> $LOG_SUCCESS

# Run this container forever (for purpose of this demo);
[ -e $LOG_SUCCESS ] && tail -f /dev/null

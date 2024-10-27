# https://www.jenkins.io/doc/book/installing/docker/#downloading-and-running-jenkins-in-docker
# This dockerfile creates and configures Jenkins server;
FROM jenkins/jenkins:alpine3.20-jdk21

# Install plugins;
# List of plugins: https://updates.jenkins.io/download/plugins/
RUN jenkins-plugin-cli --plugins blueocean credentials-binding docker-workflow git job-dsl matrix-auth workflow-aggregator workflow-cps workflow-job

# Install docker;
#USER root
#RUN apk add docker
#RUN apk add docker-cli
#RUN apk update && apk add lsb-release
#RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
#  https://download.docker.com/linux/debian/gpg
#RUN echo "deb [arch=$(dpkg --print-architecture) \
#  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
#  https://download.docker.com/linux/debian \
#  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
#RUN apk update && apk add docker-ce-cli

# Set up admin user and password;
ARG JENKINS_PASS="pass"
ARG JENKINS_USER="user"
ENV JENKINS_PASS=${JENKINS_PASS}
ENV JENKINS_USER=${JENKINS_USER}

USER jenkins

# Start-up scripts to set number of executors and creating the admin user;
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

# Skip the initial setup wizard;
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true

VOLUME /var/jenkins_home

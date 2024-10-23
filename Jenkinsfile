pipeline {
    agent any
    environment {
        CREDENTIALS_ID = 'dh-petclinic'
        DOCKERHUB_CREDENTIALS = credentials('dh-petclinic')
        DOCKER_FILE = 'Dockerfile'
        IMAGE_NAME = 'petclinic'
        REPO = 'taliadh'
        VERSION = "ver${env.BUILD_NUMBER}"
        WORK_DIR = "./"
    }
    stages {
        stage('SCA') {
            steps {
                script {
                    sh '''
                    docker build -f ${WORK_DIR}${DOCKER_FILE} --target sca --tag ${IMAGE_NAME}:${VERSION}-sca ${WORK_DIR}
                    '''
                }
            }
        }
        stage('Build'){
            steps {
                script {
                    sh "docker build -f ${WORK_DIR}${DOCKER_FILE} --target build --tag ${IMAGE_NAME}:${VERSION}-build ${WORK_DIR}"
                }    
            }
        }
        stage('Create Deployable Image') {
            steps {
                script {
                    sh "docker build -f ${WORK_DIR}${DOCKER_FILE} --target deploy --tag ${REPO}/${IMAGE_NAME}:${VERSION} ${WORK_DIR}"
                }
            }
        }
        stage('Login to Registry') {
            steps {
                sh '''
                echo $DOCKERHUB_CREDENTIALS_USR
                echo $DOCKERHUB_CREDENTIALS_PSW
                '''
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry("", "${CREDENTIALS_ID}") {
                        sh '''
                        docker tag ${REPO}/${IMAGE_NAME}:${VERSION} ${REPO}/${IMAGE_NAME}:latest
                        docker push ${REPO}/${IMAGE_NAME}:${VERSION}
                        docker push ${REPO}/${IMAGE_NAME}:latest
                        '''
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'All docker stages completed successfully!'
        }
        failure {
            echo 'Oops; Something went wrong :/'
        }
    }
}

pipeline {
    agent any

    environment {
        DOCKER_USER = 'fouedddd'     // Ton username DockerHub
        DOCKER_REPO = 'mywebapp'
        IMAGE_NAME = "${DOCKER_USER}/${DOCKER_REPO}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/FouedBenRhayem/docker-test.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh script: '''#!/bin/bash
docker run --rm \
    -v "$PWD":/usr/src \
    -e SONAR_HOST_URL=http://172.17.0.1:9000 \
    -e SONAR_LOGIN="$SONAR_TOKEN" \
    sonarsource/sonar-scanner-cli
'''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Login DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'TOKEN')]) {
                    sh "echo $TOKEN | docker login --username ${DOCKER_USER} --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}"
            }
        }

        stage('Run Container') {
            steps {
                sh """
                    docker stop mywebapp-container || true
                    docker rm mywebapp-container || true
                    docker run -d -p 80:80 --name mywebapp-container ${IMAGE_NAME}
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline terminé !"
        }
    }
}


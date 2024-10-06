pipeline {
    agent {
        label 'docker'
    }

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
        IMAGE_REPO_NAME = "java-app"
        IMAGE_TAG = "v1"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }

    stages {
        stage('Login to ECR') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'AWS_ACCOUNT_ID', variable: 'AWS_ACCOUNT_ID')]) {
                        sh """
                            aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | 
                            docker login --username AWS --password-stdin ${REPOSITORY_URI}
                        """
                    }
                }
            }
        }

        stage('Git Checkout') {
            steps {
                script {
                    checkout scmGit(
                        branches: [[name: '*/dev']],
                        extensions: [],
                        userRemoteConfigs: [[url: 'https://github.com/srdangat/java-tomcat.git']]
                    )
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Tag Image & Push to ECR') {
            steps {
                script {
                    sh """
                        docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}
                        docker push ${REPOSITORY_URI}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}

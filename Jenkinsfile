pipeline {
    agent any

    environment {
        // AWS credentials for accessing AWS ECR
        AWS_ACCESS_KEY_ID = credentials('mycreds') // Jenkins credential ID for AWS Access Key
        AWS_SECRET_ACCESS_KEY = credentials('mycreds') // Jenkins credential ID for AWS Secret Key
        ECR_REPO_URI = '533083429922.dkr.ecr.ap-south-1.amazonaws.com/' // AWS ECR repository URI
        EC2_IP = '13.233.87.108' // EC2 public IP
        EC2_USER = 'ubunty' // EC2 SSH user
        EC2_SSH_KEY = credentials('9f5768f7-f4cd-4345-bcb9-9480f7950ca3') // Use Jenkins SSH key credentials
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/kushal-vithalani/my-repo.gitt' // Replace with your repo URL
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                dir('backend') {
                    script {
                        // Build the backend Docker image
                        sh 'docker build -t backend-image .'
                    }
                }
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                dir('frontend') {
                    script {
                        // Build the frontend Docker image
                        sh 'docker build -t frontend-image .'
                    }
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    // Login to AWS ECR
                    sh '''
                    aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $ECR_REPO_URI
                    '''
                }
            }
        }

        stage('Push Backend to AWS ECR') {
            steps {
                script {
                    // Tag and push the backend Docker image to AWS ECR
                    sh 'docker tag backend-image:latest $ECR_REPO_URI/backend-image:latest'
                    sh 'docker push $ECR_REPO_URI/backend-image:latest'
                }
            }
        }

        stage('Push Frontend to AWS ECR') {
            steps {
                script {
                    // Tag and push the frontend Docker image to AWS ECR
                    sh 'docker tag frontend-image:latest $ECR_REPO_URI/frontend-image:latest'
                    sh 'docker push $ECR_REPO_URI/frontend-image:latest'
                }
            }
        }

        stage('Deploy Backend to EC2') {
            steps {
                script {
                    // Deploy the backend container to EC2
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i $EC2_SSH_KEY $EC2_USER@$EC2_IP <<EOF
                    docker pull $ECR_REPO_URI/backend-image:latest
                    docker stop backend-container || true
                    docker rm backend-container || true
                    docker run -d -p 5000:5000 --name backend-container $ECR_REPO_URI/backend-image:latest
                    EOF
                    '''
                }
            }
        }

        stage('Deploy Frontend to EC2') {
            steps {
                script {
                    // Deploy the frontend container to EC2
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i $EC2_SSH_KEY $EC2_USER@$EC2_IP <<EOF
                    docker pull $ECR_REPO_URI/frontend-image:latest
                    docker stop frontend-container || true
                    docker rm frontend-container || true
                    docker run -d -p 80:80 --name frontend-container $ECR_REPO_URI/frontend-image:latest
                    EOF
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Deployment Failed!"
        }
    }
}

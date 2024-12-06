pipeline {
    agent any
    environment {
        BACKEND_IMAGE = 'backend-image'
        FRONTEND_IMAGE = 'frontend-image'
        ECR_URL = '533083429922.dkr.ecr.ap-south-1.amazonaws.com'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/kushal-vithalani/my-repo.git'
            }
        }
        stage('Build Backend Docker Image') {
            steps {
                script {
                    sh '''
                    cd backend
                    docker build -t $BACKEND_IMAGE .
                    docker tag $BACKEND_IMAGE:latest $ECR_URL/$BACKEND_IMAGE:latest
                    '''
                }
            }
        }
        stage('Build Frontend Docker Image') {
            steps {
                script {
                    sh '''
                    cd frontend
                    docker build -t $FRONTEND_IMAGE .
                    docker tag $FRONTEND_IMAGE:latest $ECR_URL/$FRONTEND_IMAGE:latest
                    '''
                }
            }
        }
        stage('Push Images to ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region YOUR_REGION | docker login --username AWS --password-stdin $ECR_URL
                    docker push $ECR_URL/$BACKEND_IMAGE:latest
                    docker push $ECR_URL/$FRONTEND_IMAGE:latest
                    '''
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@<EC2_IP> <<EOF
                    docker pull $ECR_URL/$BACKEND_IMAGE:latest
                    docker pull $ECR_URL/$FRONTEND_IMAGE:latest
                    docker run -d -p 5000:5000 $ECR_URL/$BACKEND_IMAGE:latest
                    docker run -d -p 80:80 $ECR_URL/$FRONTEND_IMAGE:latest
                    EOF
                    '''
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline Completed'
        }
    }
}


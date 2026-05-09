pipeline {
    agent any

    environment {
        IMAGE_NAME = "contact-management-system"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Pulling latest code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests inside the built image...'
                sh "docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} python -m pytest tests/ -v --tb=short"
            }
        }

        stage('Deploy') {
            steps {
                echo 'Starting the app...'
                sh "docker compose up -d cms"
            }
        }
    }

    post {
        success {
            echo 'Pipeline passed. App is running at http://localhost:8501'
        }
        failure {
            echo 'Pipeline failed. Check the stage above for the error.'
        }
    }
}

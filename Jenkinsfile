pipeline {
    agent any

    environment {
        IMAGE_NAME  = "contact-management-system"
        IMAGE_TAG   = "latest"
        COMPOSE_FILE = "docker-compose.yml"
    }

    stages {

        // ── Stage 1: Checkout ────────────────────────────────────────────────
        stage('Checkout') {
            steps {
                echo '📥 Checking out source code...'
                checkout scm
            }
        }

        // ── Stage 2: Run Tests ───────────────────────────────────────────────
        stage('Test') {
            // Run tests inside a Python container — no need for Python on Jenkins
            agent {
                docker {
                    image 'python:3.11-slim'
                    reuseNode true   // share the workspace checked out by the outer agent
                }
            }
            steps {
                echo '🧪 Running unit tests inside python:3.11-slim container...'
                sh '''
                    pip install --quiet -r requirements.txt
                    pip install --quiet pytest
                    pytest tests/ -v --tb=short
                '''
            }
            post {
                failure {
                    echo '❌ Tests failed — aborting pipeline. Docker image will NOT be built.'
                }
                success {
                    echo '✅ All tests passed.'
                }
            }
        }

        // ── Stage 3: Build Docker Image ──────────────────────────────────────
        stage('Build') {
            steps {
                echo '🐳 Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                echo "✅ Image built: ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        // ── Stage 4: Deploy ──────────────────────────────────────────────────
        stage('Deploy') {
            steps {
                echo '🚀 Deploying CMS container...'
                // Bring down the old CMS container and start a fresh one
                sh "docker compose -f ${COMPOSE_FILE} up -d --no-build cms"
                echo '✅ CMS is live at http://localhost:8501'
            }
        }
    }

    // ── Post-pipeline notifications ──────────────────────────────────────────
    post {
        success {
            echo '🎉 Pipeline completed successfully! CMS is deployed.'
        }
        failure {
            echo '🔴 Pipeline FAILED. Check the stage logs above for details.'
        }
        always {
            echo '🧹 Pipeline finished.'
        }
    }
}

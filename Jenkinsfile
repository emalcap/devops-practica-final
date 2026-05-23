pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'emalcap/backend-final'
        DOCKER_TAG = "jenkins-${BUILD_NUMBER}"
    }

    stages {
        stage('Clonar repositorio') {
            steps {
                git branch: 'jenkins',
                    url: 'https://github.com/emalcap/devops-practica-final.git'
            }
        }

        stage('Verificar archivos') {
            steps {
                bat 'echo "=== Archivos en el repositorio ==="'
                bat 'dir'
            }
        }

        stage('Construir imagen Docker') {
            steps {
                bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Verificar imagen') {
            steps {
                bat 'docker images | findstr emalcap'
            }
        }

        stage('Limpiar contenedores anteriores') {
            steps {
                bat "docker stop test-backend-${BUILD_NUMBER} || true"
                bat "docker rm test-backend-${BUILD_NUMBER} || true"
            }
        }

        stage('Ejecutar contenedor de prueba') {
            steps {
                bat "docker run -d --name test-backend-${BUILD_NUMBER} -p 3001:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                bat 'timeout /t 5 /nobreak'
            }
        }

        stage('Probar contenedor') {
            steps {
                bat 'docker ps | findstr test-backend'
            }
        }
    }

    post {
        always {
            bat "docker stop test-backend-${BUILD_NUMBER} || true"
            bat "docker rm test-backend-${BUILD_NUMBER} || true"
            cleanWs()
        }
        success {
            echo '✅ Pipeline ejecutado exitosamente!'
        }
        failure {
            echo '❌ Pipeline falló'
        }
    }
}
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

        stage('Construir imagen Docker') {
            steps {
                bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Verificar imagen') {
            steps {
                bat "docker images | findstr ${DOCKER_IMAGE}"
            }
        }

        stage('Limpiar contenedor anterior') {
            steps {
                bat "docker stop test-backend-${BUILD_NUMBER} & exit 0"
                bat "docker rm test-backend-${BUILD_NUMBER} & exit 0"
            }
        }

        stage('Ejecutar contenedor') {
            steps {
                bat "docker run -d --name test-backend-${BUILD_NUMBER} -p 3001:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                bat "ping 127.0.0.1 -n 6 > nul"
            }
        }

        stage('Ver logs del contenedor') {
            steps {
                bat "docker logs test-backend-${BUILD_NUMBER}"
            }
        }

        stage('Verificar contenedor corriendo') {
            steps {
                bat "docker ps -a | findstr test-backend-${BUILD_NUMBER}"
            }
        }
    }

    post {
        always {
            bat "docker stop test-backend-${BUILD_NUMBER} & exit 0"
            bat "docker rm test-backend-${BUILD_NUMBER} & exit 0"
            cleanWs()
        }
        success {
            echo '✅ Pipeline EXITOSO en rama jenkins'
        }
        failure {
            echo '❌ Pipeline falló'
        }
    }
}
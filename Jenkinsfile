pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'Java_Home'
    }

    environment {
        SONARQUBE_ENV = 'SonarQubeServer'
        DOCKER_IMAGE = 'ibudaa/sonarqube-inclass:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/BudaOP/sonarqube_inclass', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    withCredentials([string(credentialsId: 'sonar_token', variable: 'SONAR_TOKEN')]) {
                        bat 'mvn sonar:sonar -Dsonar.token=%SONAR_TOKEN%'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build and Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker build -t %DOCKER_IMAGE% .
                        docker push %DOCKER_IMAGE%
                    """
                }
            }
        }
    }
}

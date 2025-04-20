pipeline {
    agent any

    tools {
        maven 'Maven'       // Name from Jenkins tool config
        jdk 'Java_Home'     // Name from Jenkins tool config
    }

    environment {
        SONARQUBE_ENV = 'SonarQubeServer'      // From Jenkins Global Config
        DOCKER_IMAGE = 'your-dockerhub-username/sonarqube-inclass:latest'
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

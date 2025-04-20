pipeline {
    agent any

    tools {
        maven 'Maven'       // Exactly as named in Jenkins > Global Tool Configuration
        jdk 'Java_Home'     // Must match the name of your JDK in Jenkins tools
    }

    environment {
        SONARQUBE_ENV = 'SonarQubeServer' // Name of the SonarQube server config in Jenkins
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
                        bat "mvn sonar:sonar -Dsonar.token=%SONAR_TOKEN%"
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
    }
}

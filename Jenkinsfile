pipeline {
    agent any

    tools {
        maven 'Maven'       // Name defined in Jenkins Global Tool Configuration
        jdk 'Java_Home'     // JDK name in Jenkins Global Tool Configuration
    }

    environment {
        SONARQUBE_ENV = 'SonarQubeServer' // SonarQube server name in Jenkins config
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/BudaOP/sonarqube_inclass', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                bat '"%MAVEN_HOME%\\bin\\mvn" clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar_token', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv("${SONARQUBE_ENV}") {
                        bat '"%MAVEN_HOME%\\bin\\mvn" sonar:sonar -Dsonar.token=%SONAR_TOKEN%'
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

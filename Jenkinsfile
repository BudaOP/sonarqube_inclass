pipeline {
    agent any

    tools {
        maven 'Maven'       // Use the name exactly as in Jenkins Global Tool Config
        jdk 'Java_Home'     // Use the name you set for JDK in Jenkins
    }

    environment {
        SONARQUBE_ENV = 'SonarQubeServer' // Name you gave your SonarQube server config
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
                    bat 'mvn sonar:sonar'
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

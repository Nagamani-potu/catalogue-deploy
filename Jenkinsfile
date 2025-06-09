pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }

    // environment {
    //     packageVersion = ''
    //     nexusURL = '172.31.22.176:8081' // ✅ Port included
    // }

    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }
    parameters {
        string(name: 'version', defaultValue: '', description: 'What is the artifact version?')
        string(name: 'environment', defaultValue: 'dev', description: 'What is environment?')
        booleanParam(name: 'Destroy', defaultValue: 'false', description: 'What is Destroy?')
        booleanParam(name: 'Create', defaultValue: 'false', description: 'What is Create?')
    }
    stages {
        stage('Get the version') {
            steps {
                script {
                    def packageJson = readJSON file: 'package.json'
                    packageVersion = packageJson.version
                    echo "Application version: $packageVersion"
                }
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    ls -la
                    zip -q -r catalogue.zip ./Jenkinsfile ./node_modules ./package.json ./package-lock.json ./schema ./server.js -x ".git/*" -x "*.zip"
                    ls -ltr
                '''
            }
        }

        stage('Verify Artifact') {
            steps {
                sh 'ls -lh catalogue.zip'
            }
        }

        stage('Publish Artifact') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: "${nexusURL}",
                    groupId: 'com.roboshop',
                    version: "${packageVersion}",
                    repository: 'catalogue',
                    credentialsId: 'nexus-auth',
                    artifacts: [[
                        artifactId: 'catalogue',
                        classifier: '',
                        file: 'catalogue.zip',
                        type: 'zip'
                    ]]
                )
            }
        }

        stage('Deploy') {
            steps {
                sh 'echo "Here I wrote shell script"'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed. Cleaning up workspace...'
            deleteDir()
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
        }
        success {
            echo 'Pipeline succeeded. Artifact published and deployment complete.'
        }
    }
}

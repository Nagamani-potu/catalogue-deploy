pipeline {
    agent any

    parameters {
        string(name: 'version', defaultValue: 'v1.0.0', description: 'Application Version')
        string(name: 'environment', defaultValue: 'dev', description: 'Deployment Environment')
        booleanParam(name: 'Create', defaultValue: true, description: 'Create Infrastructure')
        booleanParam(name: 'Destroy', defaultValue: false, description: 'Destroy Infrastructure')
    }

    stages {
        stage('Print version') {
            steps {
                sh """
                    echo "version: ${params.version}"
                    echo "environment: ${params.environment}"
                """
            }
        }

        stage('Init') {
            steps {
                sh """
                    cd terraform
                    terraform init --backend-config=${params.environment}/backend.tf -reconfigure
                """
            }
        }

        stage('Plan') {
            when {
                expression { params.Create }
            }
            steps {
                sh """
                    cd terraform
                    terraform plan -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}"
                """
            }
        }

        stage('Apply') {
            when {
                expression { params.Create }
            }
            steps {
                sh """
                    cd terraform
                    terraform apply -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}" -auto-approve
                """
            }
        }

        stage('Destroy') {
            when {
                expression { params.Destroy }
            }
            steps {
                sh """
                    cd terraform
                    terraform destroy -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}" -auto-approve
                """
            }
        }
    }

    post { 
        always { 
            echo 'I will always say Hello again!'
            deleteDir()
        }
        failure { 
            echo 'this runs when pipeline is failed, used generally to send some alerts'
        }
        success {
            echo 'I will say Hello when pipeline is success'
        }
    }
}

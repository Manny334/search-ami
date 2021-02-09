pipeline {
    agent any
    stages{
        stage('Checkout') {
            steps {
                git checkout scm
            }
        }
        stage('Validate') {
            steps {
                sh 'packer validate -var-file fw-search-variables.json fw-search-ami.json'
            }
        }
        stage('Build') {
            steps {
                withCredentials([string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
                string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                       sh 'packer build -var-file fw-search-variables.json fw-search-ami.json'
                    }
                }
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform plan') {
            steps {
                script [
                    sh 'terraform plan'
                ]
            }
        }
        stage('Terraform Approval') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm']])
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply --auto-approve'
                }
            }
        }
    }
}

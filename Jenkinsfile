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
                input 'Approve Terraform Plan?'
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

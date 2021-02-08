#!groovy
node {
    def err = null
    def environment = "Dev"
    currentBuild.result = "SUCCESS"

    try {
        stage('Checkout'){
            checkout scm
        }


        stage('Validate'){
            sh """packer validate -var-file fw-search-variables.json fw-search-ami.json"""
        }

        stage('Build'){
            withCredentials([string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')]){
                sh """
                packer build -var-file fw-search-variables.json fw-search-ami.json
                """
            }
        }
        stage('Terraform init'){
            sh """terraform init"""
        }
        stage('Terraform plan'){
            sh """terraform plan"""
        }
        stage('Terraform approval'){
            def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm']])
        }
        stage('Terraform apply'){
                sh """terraform apply -auto-approve"""
        }
    }
    catch(caughtError){
        err = caughtError
        currentBuild.result = "FAILURE"
    }
    finally{
        if (err) {
            throw err
        }
    }
}

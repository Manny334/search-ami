pipeline{
    agent any{
        environment{
            REGION='us-east-1'
            ENVIRONMENT = 'dev'
        }
    }
    stages {
        stage ('checkout'){
            steps {
                checkout scm
            }
        }
        stage ('validate'){
            sh 'packer validate fw-search-ami.json'
        }
        stage('Build'){
            withCredentials([usernamePassword(credentialsId: 'AWS_CREDENTIALS', accessKeyVariable: 'AWS_ACCESS_KEY',passwordKeyVaraible: 'AWS_SECRET_KEY')])
            //Run the packer build
            sh "packer build fw-search-ami.json"
        }
    }
}

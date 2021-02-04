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
            sh """
            set +x
            packer validate fw-search-ami.json
            """
        }

        stage('Build'){
            withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]){
                sh """
                set +x
                packer build -var fw-search-variables.json fw-search-ami.json
                """
            }
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

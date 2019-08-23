#!/usr/bin/groovy

def project = "expenseManagerFrontend"
def version = -1
def imageName = "expense-manager-frontend"

node {
    stage('Checkout') {
        def file = new File("checkout.sh")
        if (!file.exists()) {
            git(
                url: 'https://github.com/cjmason8/expenseManagerFrontendConfig.git',
                credentialsId: 'Github',
                branch: "master"
            )
            dir('expenseManagerFrontend') {
                git(
                    url: 'https://github.com/cjmason8/expenseManagerFrontend.git',
                    credentialsId: 'Github',
                    branch: "master"
                )    
            }
        }

        withCredentials([usernamePassword(credentialsId: 'Github', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            sh './checkout.sh $PASSWORD expenseManagerFrontend'
        }
    }

    stage('Update Version') {
        withCredentials([usernamePassword(credentialsId: 'Github', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            sh './updateVersion.sh $PASSWORD expenseManagerFrontend'
        }

        version = readFile('VERSION').trim()
    }

    stage('Build') {
        sh "./build.sh $imageName $version"
    }

    stage('Tag and Push') {
        sh "./tagAndPush.sh $imageName $version"
    }

    stage('Deploy') {
        withCredentials([usernamePassword(credentialsId: 'Rancher', passwordVariable: 'SECRETKEY', usernameVariable: 'ACCESSKEY')]) {
            sh './deploy.sh $ACCESSKEY $SECRETKEY http://167.86.68.204:8080/v2-beta/projects/1a5 prd'
        }
    }
}

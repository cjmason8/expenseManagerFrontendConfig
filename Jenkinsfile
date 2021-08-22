#!/usr/bin/groovy

def project = "expenseManagerFrontend"
def version = -1
def imageName = "expense-manager-frontend"

node {
    stage('Delete Workspace') {
        sh 'rm -rf *'
        sh 'rm -rf .git'
        sh 'rm -f .gitignore'
    }

    stage('Checkout') {
        sh 'git clone git@github.com:cjmason8/expenseManagerFrontendConfig.git .'
        sh 'git clone git@github.com:cjmason8/expenseManagerFrontend.git'
    }

    stage('Update Version') {
        sh './updateVersion.sh'

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
            sh './deploy.sh $ACCESSKEY $SECRETKEY http://161.97.133.187:8080/v2-beta/projects/1a5 prd'
        }
    }
}

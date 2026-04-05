pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
        SNYK_ORG           = credentials('snyk-org-slug')
    }

    options {
        ansiColor('xterm')
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // stage('Snyk IaC Scan Test') {
        //     steps {
        //         withCredentials([string(credentialsId: 'snyk-api-token-string', variable: 'SNYK_TOKEN')]) {
        //             sh '''
        //                 export PATH=$PATH:/var/lib/jenkins/tools/io.snyk.jenkins.tools.SnykInstallation/snyk
        //                 snyk-linux auth $SNYK_TOKEN
        //                 snyk-linux iac test --org=$SNYK_ORG --severity-threshold=high || true
        //             '''
        //         }
        //     }
        // }

        stage('Snyk IaC Scan Monitor') {
            steps {
                snykSecurity(
                    snykInstallation: 'snyk',
                    snykTokenId: 'snyk-api-token',
                    additionalArguments: '--iac --report --org=$SNYK_ORG --severity-threshold=high',
                    failOnIssues: true,
                    monitorProjectOnBuild: false
                )
            }
        }

        stage('Terraform Init, Format & Validate') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'armageddon'
                ]]) {
                    sh '''
                        terraform init
                        terraform fmt -check -recursive
                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'armageddon'
                ]]) {
                    sh '''
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Approval Gate') {
            when {
                branch 'main'
            }
            steps {
                timeout(time: 60, unit: 'MINUTES') {
                    input message: 'Review the Terraform plan above and approve deployment?', 
                          ok: 'Deploy to Infrastructure'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'armageddon'
                ]]) {
                    sh '''
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Terraform Destroy (Manual)') {
            when {
                expression { false }
            }
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to run terraform destroy?',
                        parameters: [
                            choice(name: 'DESTROY', choices: ['no', 'yes'], description: 'Confirm destruction of all Terraform resources')
                        ]
                    )
                    if (destroyChoice == 'yes') {
                        withCredentials([[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'armageddon'
                        ]]) {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo 'Destroy operation skipped.'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed. Review Snyk reports in the Snyk dashboard for any findings.'
        }
        success {
            echo 'Infrastructure deployment completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please review logs, Terraform plan, and Snyk findings.'
        }
    }
}
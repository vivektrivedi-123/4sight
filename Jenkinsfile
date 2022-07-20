pipeline{
    agent{
        label 'docker_system'
    }
    options{
        timestamps ()
        disableConcurrentBuilds()
    }
    stages{
        stage('Checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/dev']], extensions: [], userRemoteConfigs: [[credentialsId: 'vivek-ssh', url: 'git@github.com:vivektrivedi-123/4sight.git']]])
            }
        }
        stage('Build'){
            agent{
                docker{image '4sight:latest'
                       reuseNode true
                       args '-u 1000 -v $WORKSPACE:/app -w /app'
                }
            }
            steps{
                sh label: '', script: '''
                sudo npm i
                sudo npm run build
                sudo zip -r build.zip build
                sudo chown -R 1000:1000 *
                '''
            }
        }
        stage('Artifacts'){
            steps{
                archiveArtifacts 'build.zip'
            }
        }
    }
    post{
        failure{
            emailext attachLog: true, body:'''
Please find the attachments.


Regards,
Jenkins Admin''', compressLog: true, subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'jenkinspedia@gmail.com'
        }
        success{
            emailext attachmentPatterns: 'build.zip', body: '''
Plesae find the attachments. 


Regards,
Jenkins Admin''', compressLog: false, subject: '$PROJECT_NAME - Build # $BUILD_NUBMER - $BUILD_STATUS', to: 'jenkinspedia@gmail.com'
        }
    }
}

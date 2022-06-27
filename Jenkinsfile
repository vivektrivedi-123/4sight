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
                echo "this is testing purpose."
                sudo chown -R 1000:1000 *
                '''
            }
        }
        stage('Artifacts'){
            steps{
                archiveArtifacts 'build.tar'
            }
        }
    }
    post{
        failure{
            emailext attachLog: true, body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:
Changes     :   $GIT_CHANGE_ID
Branch      :   $GIT_BRANCH
URL         :   $GIT_CHANGE_URL
Please find the attachement. ''', compressLog: true, subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS', to: 'sample@gmail.com'
        }
        success{
            emailext attachmentPatterns: 'build.zip', body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:
Changes     :   $GIT_CHANGE_ID
Branch      :   $GIT_BRANCH
URL         :   $GIT_CHANGE_URL
Plesae find the attachment. ''', compressLog: false, subject: '$PROJECT_NAME - Build # $BUILD_NUBMER - $BUILD_STATUS', to: 'sample@gmail.com'
        }
    }
}

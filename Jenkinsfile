// Define variables
def _user="appuser"
def _home="/home/" + _user

properties(
    [
        disableConcurrentBuilds()
    ]
)
pipeline {
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent {
        docker { 
            image 'ts-dockerhub.lsst.org/robotsal:latest'
            args '-w ' + _home + ' -e AWS_ACCESS_KEY_ID=$aws_key_id -e AWS_SECRET_ACCESS_KEY=$aws_secret_key ' + 
            '-v ${WORKSPACE}:' + _home + '/trunk'
         }
    }
    stages {
        stage('Cleanup bleed bucket') {
            steps {
                sh "./s3cmdclearfiles.sh sal-objects/bleed/ 30d"
            }
        }//Bleed
        stage('Cleanup daily bucket') {
            steps {
                sh "./s3cmdclearfiles.sh sal-objects/daily/ 30d"
            }
        }//Daily
        stage('Cleanup release bucket') {
            steps {
                sh "./s3cmdclearfiles.sh sal-objects/release/ 30d"
            }
        }//Release
    }//stages
    post { 
        cleanup {
            deleteDir() /* clean up our workspace */
        }
    }//post
}//pipeline

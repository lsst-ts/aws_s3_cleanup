// Define variables
def _user="saluser"
def _home="/home/" + _user

properties(
    [
        disableConcurrentBuilds()
    ]
)
pipeline {
    triggers {
        // Run the job on the first of every month, between midnight and 1am.
        cron('H H(0-1) 1 * *')
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent {
        docker { 
            image 'ts-dockerhub.lsst.org/robotsal:latest'
            args '-w ' + _home + ' -e AWS_ACCESS_KEY_ID=$aws_key_id -e AWS_SECRET_ACCESS_KEY=$aws_secret_key ' + 
            '-v ${WORKSPACE}:' + _home + '/repos'
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
        stage('Cleanup release candidatess bucket') {
            steps {
                sh "./s3cmdclearfiles.sh sal-objects/release_candidates/ 180d"
            }
        }//ReleaseCandidates
        stage('Cleanup releases bucket') {
            steps {
                sh "./s3cmdclearfiles.sh sal-objects/releases/ 365d"
            }
        }//Releases
    }//stages
    post { 
        always {
            emailext attachLog: true, body: '', subject: '[Jenkins] AWS Cleanup complete', to: 'rbovill@lsst.org'
        }
        cleanup {
            deleteDir() /* clean up our workspace */
        }
    }//post
}//pipeline

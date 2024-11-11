pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
        REPOSITORY = 'quay.io/omidiyanto' 
        APP_NAME = 'perpus-laravel' 
        YAML_PATH = 'Kubernetes/k8s.yml' 
    }
    stages {
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/omidiyanto/perpus-laravel.git'
            }
        }
        stage("Sonarqube Analysis ") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Perpus-laravel \
                    -Dsonar.projectKey=Perpus-laravel '''
                }
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'quay.io-account', url: 'https://quay.io', toolName: 'docker') {
                        sh "docker build -t ${env.REPOSITORY}/${env.APP_NAME}:${env.IMAGE_TAG} ."
                        sh "docker push ${env.REPOSITORY}/${env.APP_NAME}:${env.IMAGE_TAG}"
                    }
                }
            }
        }
        stage("TRIVY IMAGE SCAN") {
            steps {
                sh "trivy image ${env.REPOSITORY}/${env.APP_NAME}:${env.IMAGE_TAG} > trivyimage.txt"
            }
        }
        stage("Deploy to k8s") {
            steps {
                script {
                    sh "sed -i 's|${env.REPOSITORY}/${env.APP_NAME}:latest|${env.REPOSITORY}/${env.APP_NAME}:${env.IMAGE_TAG}|g' ${env.YAML_PATH}"
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kubeconfig', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                        sh "kubectl apply -f ${env.YAML_PATH}"
                    }
                }
            }
        }
    }
    post {
        always {
            emailext(
                attachLog: true,
                subject: "Jenkins Report - ${env.JOB_NAME}#${env.BUILD_NUMBER}",
                body: "Results: '${currentBuild.result}'",
                to: 'midiyanto26@gmail.com',
                attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
            )
        }
    }
}

pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
          - name: docker
            image: docker:19.03.1-dind
            securityContext:
              privileged: true
            env:
              - name: DOCKER_TLS_CERTDIR
                value: ""  
                '''
    }
  }
  stages {
    
    stage('Build-Jar-file') {
      steps {
        container('maven') {
          sh 'mvn package'
        }
      }
    }

    stage('Docker Build and Push') {         
      steps {   
        container('docker') {
            withCredentials([usernamePassword(credentialsId: 'docker-creds', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
            sh 'docker build -t thangap05/demo-liefbit:1.0 .'
            sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
            sh 'docker push thangap05/demo-liefbit:1.0'
      }
    }
    }
    }
  }
    post {
      always {
        container('docker') {
          sh 'docker logout'
      }
      }
    }
}
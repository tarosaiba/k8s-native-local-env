pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/jenkins-pod.yaml'
    }

  }

  stages {
    stage('Build') {
      steps {
        container(name: 'kaniko') {
          sh "ls"
          sh "/kaniko/executor --context `pwd` --insecure --skip-tls-verify --destination registry.jenkins.svc:5000/album-api:latest"
        }

      }
    }

    stage('Test') {
      steps {
        container(name: 'kustomize') {
          sh """
          set +e
          kubectl create namespace $PROJECT-${env.BRANCH_NAME.toLowerCase()}
          set -e
          """
          sh "kubectl apply -f k3s.yaml -n $PROJECT-${env.BRANCH_NAME.toLowerCase()}"
          sh "kubectl get pods -n $PROJECT-${env.BRANCH_NAME.toLowerCase()}"
          sh "kubectl -n $PROJECT-${env.BRANCH_NAME.toLowerCase()} rollout status deployment album-api"
          sh "kubectl get pods -n $PROJECT-${env.BRANCH_NAME.toLowerCase()}"
          sh "sleep 60"
          sh "curl http://album-api.$PROJECT-${env.BRANCH_NAME.toLowerCase()}.svc:8080/albums"
          sh "kubectl delete namespace $PROJECT-${env.BRANCH_NAME.toLowerCase()}"
        }

      }
    }
  }
  environment {
    PROJECT = 'jenkins-demo'
  }
}

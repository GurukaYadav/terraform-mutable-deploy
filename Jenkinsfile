pipeline {
  agent any
  options {
    ansiColor('xterm')
  }
  parameters {
    choice(name: 'COMPONENT', choices: ['cart', 'catalogue', 'user', 'frontend', 'shipping', 'payment', 'dispatch'], description: 'Choose COMPONENT')
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose ENV')
  }

  stages {
    stage('terraform') {
      steps {
        sh '''
          terraform init
          terraform plan
          terraform apply -auto-approve -var COMPONENT=${COMPONENT} -var ENV=${ENV}
        '''
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
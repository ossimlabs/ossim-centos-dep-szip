properties([
    parameters ([
        string(name: 'DOCKER_REGISTRY_DOWNLOAD_URL', defaultValue: 'nexus-docker-private-group.ossim.io', description: 'Repository of docker images'),
    ]),
    pipelineTriggers([
            [$class: "GitHubPushTrigger"]
    ]),
    [$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/ossimlabs/ossim-szip'],
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '3', daysToKeepStr: '', numToKeepStr: '20')),
    disableConcurrentBuilds()
])
podTemplate(
  containers: [
    containerTemplate(
      name: 'builder',
      image: "${DOCKER_REGISTRY_DOWNLOAD_URL}/ossim-deps-builder:1.0",
      ttyEnabled: true,
      command: 'cat',
      privileged: true
    )
    
  ],
  volumes: [
    hostPathVolume(
      hostPath: '/var/run/docker.sock',
      mountPath: '/var/run/docker.sock'
    ),
  ]
)

{

node(POD_LABEL){
    stage("Checkout branch $BRANCH_NAME")
    {
        checkout(scm)
    }
    
    stage("Load Variables")
    {
      withCredentials([string(credentialsId: 'o2-artifact-project', variable: 'o2ArtifactProject')]) {
        step ([$class: "CopyArtifact",
          projectName: o2ArtifactProject,
          filter: "common-variables.groovy",
          flatten: true])
        }
        load "common-variables.groovy"
    }

    stage (" Build szip")
    {
        container('builder') 
        {
            sh """
             ./build-szip.sh
              cd /usr/local
              tar -czvf centos-szip.tgz *
            """
        }
    }
    
    stage("Publish"){
        withCredentials([usernameColonPassword(credentialsId: 'nexusCredentials', variable: 'NEXUS_CREDENTIALS')]){
            container('builder') {
              sh """
              cd /usr/local
              curl -v -u ${NEXUS_CREDENTIALS} --upload-file centos-szip.tgz https://nexus.ossim.io/repository/ossim-dependencies/"""
            }
          }
    }
	stage("Clean Workspace"){
      step([$class: 'WsCleanup'])
  }
}
}
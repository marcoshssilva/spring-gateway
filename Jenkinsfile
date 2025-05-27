@Library(['java@main']) _
pipelineUsingJava17AndMavenWithPublicDockerImage('marcoshssilva/spring-gateway',
    [
        'APP_NAME': 'spring-gateway',
        'DEPLOY': 'DOKKU',
        'DOKKU_SELECTED_BUILDPACK': 'herokuish', // Options can be 'dockerfile', 'null' and DEFAULT 'herokuish'
        'HOST': 'spring-gateway.starlord443.dev',
    ],
)

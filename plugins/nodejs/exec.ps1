function node() {
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\node.exe" $args 
        }
    }
}

function npm() {
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\npm.cmd" $args 
        }
    }
}

function npx() {
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\npx.cmd" $args 
        }
    }
}

function yarn() {
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\node.exe" "${env:NODEJS_HOME}\node_modules\yarn\bin\yarn.js" $args 
        }
    }
}

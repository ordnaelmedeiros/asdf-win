function node() {
    .$ASDF_HOME\scripts\plugins\set-env-recursive.ps1
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\node.exe" $args 
        }
    }
}

function npm() {
    .$ASDF_HOME\scripts\plugins\set-env-recursive.ps1
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\npm.cmd" $args 
        }
    }
}

function npx() {
    .$ASDF_HOME\scripts\plugins\set-env-recursive.ps1
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\npx.cmd" $args 
        }
    }
}

function yarn() {
    .$ASDF_HOME\scripts\plugins\set-env-recursive.ps1
    if ($env:NODEJS_HOME) {
        if (test-path $env:NODEJS_HOME) {
            ."${env:NODEJS_HOME}\node.exe" "${env:NODEJS_HOME}\node_modules\yarn\bin\yarn.js" $args 
        }
    }
}

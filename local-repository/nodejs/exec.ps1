function node() {
    ."$ASDF_HOME_SCRIPTS\set-env-recursive.ps1"
    ."${env:NODEJS_HOME}\node.exe" $args     
}

function npm() {
    ."$ASDF_HOME_SCRIPTS\set-env-recursive.ps1"
    ."${env:NODEJS_HOME}\npm.cmd" $args 
}

function npx() {
    ."$ASDF_HOME_SCRIPTS\set-env-recursive.ps1"
    ."${env:NODEJS_HOME}\npx.cmd" $args 
}

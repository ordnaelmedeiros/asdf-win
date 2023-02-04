$ASDF_HOME = "${HOME}/.asdf"

function asdf() {
    param (
        
        [switch]$v,
        
        [switch]$version,

        [Alias('p')]
        [ValidateSet('java','maven', 'quarkus')]
        [string]$plugin,
        
        [Alias('i')]
        [string[]]$install,

        [Alias('l')]
        [string]$local,

        [Alias('g')]
        [string]$global

    )

    if ($v) {
        echo "--- debug params ---"
        if ($plugin) { echo "plugin: ${plugin}" }
        if ($install) { echo "install: ${install}" }
        if ($local) { echo "local: ${local}" }
        if ($global) { echo "global: ${global}" }
        echo ""
    }

    if ($version) {
        echo "asdf 1.0.0"
        return
    }

    if ($plugin) {

        if ($install) {
            foreach ($lib in $install) {
                .$ASDF_HOME/plugins/$plugin/install.ps1
            }
            return
        } 
        
        if ($local) {
            .$ASDF_HOME/plugins/$plugin/local.ps1
            return
        }

        if ($global) {
            .$ASDF_HOME/plugins/$plugin/global.ps1
            return
        }
        
        ."${ASDF_HOME}/plugins/list.ps1"
        
    } else {
        echo "-plugin is required"
    }

}

function java() {
    if ($env:JAVA_HOME) {
        if (test-path $env:JAVA_HOME) {
            ."${env:JAVA_HOME}\bin\java.exe" $args 
        }
    }
}

function mvn() {
    if ($env:MVN_HOME) {
        if (test-path $env:MVN_HOME) {
            ."${env:MVN_HOME}\bin\mvn.cmd" $args 
        }
    }
}

function quarkus() {
    if ($env:QUARKUS_JAR) {
        if (test-path $env:QUARKUS_JAR) {
            ."${env:JAVA_HOME}\bin\java.exe" -jar "${env:QUARKUS_JAR}" $args 
        }
    }
}

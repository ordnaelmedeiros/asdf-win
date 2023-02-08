function quarkus() {
    .$ASDF_HOME\scripts\plugins\set-env-recursive.ps1
    if ($env:QUARKUS_JAR) {
        if (test-path $env:QUARKUS_JAR) {
            ."${env:JAVA_HOME}\bin\java.exe" -jar "${env:QUARKUS_JAR}" $args 
        }
    }
}
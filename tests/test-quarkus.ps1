. ./asdf.ps1

if (test-path ${ASDF_HOME}/target) {
    rm -r -fo ${ASDF_HOME}/target
}
mkdir -p ${ASDF_HOME}/target 
cd ${ASDF_HOME}/target

asdf java openjdk-11.0.2 -t
asdf maven maven-3.8.7 -t
asdf quarkus quarkus-cli-2.16.1.Final -t

quarkus create app br.com.ordnaelmedeiros:asdf:1.0

cd asdf
mvn clean install test

cd ${ASDF_HOME}

. ./asdf.ps1

if (test-path ${ASDF_HOME}/target) {
    rm -r -fo ${ASDF_HOME}/target
}

asdf java openjdk-11.0.2 -g
asdf maven maven-3.8.7 -g
asdf quarkus quarkus-cli-2.16.1.Final -g

quarkus create app br.com.ordnaelmedeiros:target:1.0

cd target
asdf java openjdk-17.0.2 -l
mvn clean install test
mvn -v

cd ${ASDF_HOME}

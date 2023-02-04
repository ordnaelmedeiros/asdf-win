. ./asdf.ps1

if (test-path target) {
    rm -r fo target
}
mkdir -p target 
cd target

asdf java openjdk-11.0.1 -t
asdf maven maven-3.8.7 -t
asdf quarkus quarkus-cli-2.16.1.Final -t

quarkus create app br.com.ordnaelmedeiros:asdf:1.0

cd asdf
mvn clean install test
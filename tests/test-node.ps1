. ./asdf.ps1

if (test-path ${ASDF_HOME}/target) {
    rm -r -fo ${ASDF_HOME}/target
}
mkdir -p ${ASDF_HOME}/target 
cd ${ASDF_HOME}/target

asdf nodejs nodejs-v17.9.1 -g
node -v

asdf nodejs nodejs-v18.14.0 -l
node -v

npm init -y
npm install express

cp ../tests/index.txt index.js
node .\index.js

# http://localhost:3000/outfit

cd ${ASDF_HOME}

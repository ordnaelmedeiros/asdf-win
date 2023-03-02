$value = curl "https://dlcdn.apache.org/tomcat/tomcat-${version}/" | Select-String "folder" | Select-String -Pattern "\S"
$value = $value.ToString().Trim()
$found = $value -match '.*href="v(\S+)/".*'
$v = $matches[1]
return "https://dlcdn.apache.org/tomcat/tomcat-${version}/v${v}/bin/apache-tomcat-${v}-windows-x64.zip"

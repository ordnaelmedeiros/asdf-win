$programsPath = "${HOME}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Eclipse.lnk"
if (!(Test-Path $programsPath)) {
    New-Item -ItemType "file" -Path $programsPath -Force
}
$s=(New-Object -COM WScript.Shell).CreateShortcut($programsPath);
$s.TargetPath="$ASDF_HOME_INSTALLS\$name\$version\eclipse.exe";
$s.Save()
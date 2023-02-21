Get-ChildItem -Recurse -Path $ASDF_HOME_SRC
    | Where-Object { $_ -like "*.ps1" }
    | ForEach-Object {
        . "$_"
    }

[AsdfStatics]::ASDF_HOME = $ASDF_HOME
[AsdfStatics]::ASDF_HOME_INSTALLS = $ASDF_HOME_INSTALLS
[AsdfStatics]::ASDF_HOME_PLUGINS = $ASDF_HOME_PLUGINS
[AsdfStatics]::ASDF_HOME_LOCAL_REPO = $ASDF_HOME_LOCAL_REPO

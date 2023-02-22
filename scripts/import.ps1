. "${ASDF_HOME_SRC}\AsdfStatics.ps1"
. "${ASDF_HOME_SRC}\AsdfUtils.ps1"

. "${ASDF_HOME_SRC}\version\AsdfVersion.ps1"

. "${ASDF_HOME_SRC}\plugin\AsdfPlugin.ps1"
. "${ASDF_HOME_SRC}\plugin\AsdfPluginManager.ps1"

[AsdfStatics]::ASDF_HOME = $ASDF_HOME
[AsdfStatics]::ASDF_HOME_INSTALLS = $ASDF_HOME_INSTALLS
[AsdfStatics]::ASDF_HOME_PLUGINS = $ASDF_HOME_PLUGINS
[AsdfStatics]::ASDF_HOME_LOCAL_REPO = $ASDF_HOME_LOCAL_REPO

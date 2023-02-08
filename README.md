# asdf-win

## Requirements:

- PowerShell 7.3.x
- Git

```shell
winget install Microsoft.PowerShell
```
```shell
winget install Git.Git
```

## Install
`Use PowerShell 7.3.x`
```shell
git clone https://github.com/ordnaelmedeiros/asdf-win.git "${HOME}\.asdf" && ."${HOME}\.asdf\install.ps1"
```
Restart PowerShell

Update:
```shell
git -C "${HOME}\.asdf" pull && ."${HOME}\.asdf\install.ps1"
```

## Use

list plugins:
```shell
asdf list
```

list versions:
```shell
asdf java list
```

install version:
```shell
asdf java openjdk-11.0.2 -install
```

set global env:
```shell
asdf java openjdk-11.0.2 -global
```

create config file in project (`.win-tool-versions`):
```shell
asdf java openjdk-11.0.2 -local
```


## Recommended

in Windows environment variables, remove all references to Java, maven... etc. including Path.


<!-- ## demo

![Alt Text](demo.gif) -->
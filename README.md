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
git clone https://github.com/ordnaelmedeiros/asdf-win.git "${HOME}/.asdf" && ."${HOME}/.asdf/install.ps1"
```
Restart PowerShell

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
asdf java openjdk-11.0.2
```

set global env:
```shell
asdf java openjdk-11.0.2 -global
```

set terminal session env:
```shell
asdf java openjdk-11.0.2 -terminal
```


## Recommended

in Windows environment variables, remove all references to Java, maven... etc. including Path.


## demo

![Alt Text](demo.gif)
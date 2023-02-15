# asdf-win

Trying develop asdf for `Windows` and `PowerShell 7`

## Install:

[Microsot Store winget](https://www.microsoft.com/store/productId/9NBLGGH4NNS1)
```shell
winget install Microsoft.PowerShell
```
`Use PowerShell 7 for next steps`

```shell
winget install Git.Git
```

```shell
git clone https://github.com/ordnaelmedeiros/asdf-win.git "${HOME}\.asdf" && ."${HOME}\.asdf\install.ps1"
```
`Restart PowerShell`

update:
```shell
asdf update"
```

## How to use asdf?

- `Use PowerShell 7 always`
- CLI compatible: [asdf-vm](https://asdf-vm.com/)
- Doc: [asdf-vm doc](https://asdf-vm.com/manage/commands.html)

## Recommended

in Windows environment variables, remove all references to Java, maven... etc. including in Path.

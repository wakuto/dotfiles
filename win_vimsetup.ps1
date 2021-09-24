$dotfiles_folder = (Split-Path $MyInvocation.MyCommand.Path -Parent)
$vimrc_path = (Join-Path $dotfiles_folder .vimrc)
New-Item -Type SymbolicLink (Join-Path $HOME _vimrc) -Value $vimrc_path


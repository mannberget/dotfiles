# Configuration

Prerequisites:

- git
- [alacritty](https://github.com/alacritty/alacritty)
- [BitStreamVeraSansMono](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/BitstreamVeraSansMono.zip) (or other nerdfont)
- python
- pip (`sudo apt-get -y install python3-pip`)


## Instructions:

Start with installing packer

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Then install pylsp

`conda install -c conda-forge python-lsp-server` 
install in your project environment

`pip install python-language-server[all]`, pylsp might need to be added to the `$PATH` variable

## To swap caps and escape on ubuntu (22)`
`dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"`

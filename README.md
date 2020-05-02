# YfritLib
Useful libs used in Yfrit projects.

# How to install

This project was once used as a LuaRocks module and it's probably possible to install it that way, but we no longer support it. Currently, we only support installing through Git, as following:

If your project is a Git project, run this inside its folder:

`git submodule add https://github.com/yfrit/yfritlib.git`

If it is not a Git project, run this instead:

`git clone https://github.com/yfrit/yfritlib.git`


Alternatively, to install through LuaRocks, you can try the following:
```
git clone https://github.com/yfrit/yfritlib.git
cd yfritlib
luarocks make
```

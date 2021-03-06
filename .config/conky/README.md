My version is further modified

# klaatu-conky-conf
My Conky config. It's kind of based on [severindupouy's config](https://github.com/severindupouy/conky.conf), so thank you for that one.

The Lua script is supremely ugly with those hard-coded position values. Maybe it can be done better, but this was all the Lua I could put up with for now.

Also, I don't know why the `${top mem N}` all say `inf`. Maybe I'll dig into that some day. But then again, maybe not.

![Conky screendump](/screenshot.png)

## Usage

You need [Conky](https://github.com/brndnmtthws/conky/) with [Cairo](https://cairographics.org/manual/) support. I guess that's what you get when installing `conky-all` on Debian. Or if you compile it yourself, you have to set `BUILD_LUA_CAIRO=ON` for `cmake`. Unfortunately, I don't remember exactly how I did this. :D

You also need [Font Awesome for desktop](https://fontawesome.com/how-to-use/on-the-desktop/setup/getting-started).

My default settings will probably not work for you. You have to find out your network interface names and `hwmon` integers for yourself and change `conky.conf` accordingly. http://conky.sourceforge.net/variables.html is a great help.

The _Backup_ section is based on a highly sofisticated hack where I make my backup program (Duplicati) run a variant of this script after every backup:

```shell
echo `date +'%F %T'`: $DUPLICATI__PARSED_RESULT > /var/log/duplicati-[backup name].log
```

All that said and done -- place `conky.*` in `~/.config/conky/` and you're ready to roll.

## Startup script

In `bin/` is a script I run at startup in Ubuntu. It uses the `-m` parameter to display Conky on both my screens. This parameter is not available in Conky v1.10.8, which is the version currently (Oct 2020) available in Ubuntu's repository, hence the need for compiling it myself. It also uses `-p 1` when starting the first instance, making Conky pause for one second before doing anything, which turned out to be the solution for the fonts getting the wrong sizes on startup.

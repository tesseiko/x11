#!/bin/sh

# xinitrc runs automatically when you run startx.

# There are some small but important commands that need to be run when we start
# the graphical environment. There is a link to this file in ~/.xprofile
# because that file is run automatically if someone uses a display manager
# (login screen) and so they are needed there. To prevent doubling up commands,
# I source them here with the line below.
if [ -z "$XDG_RUNTIME_DIR" ]; then
	printf "XDG_RUNTIME_DIR isn't set\n" >&2
	exit 6
fi

_DISPLAY="$(systemd-escape -- "$DISPLAY")"
trap "rm -f $(printf '%q' "${XDG_RUNTIME_DIR}/x11-wm@${_DISPLAY}")" EXIT
mkfifo "${XDG_RUNTIME_DIR}/x11-wm@${_DISPLAY}"

cat < "${XDG_RUNTIME_DIR}/x11-wm@${_DISPLAY}" &
		systemctl --user start "X11@${_DISPLAY}.target" &
		wait
		systemctl --user stop "X11@${_DISPLAY}.target"


# if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile" ]; then
# 	. "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile"
# else
# 	. "$HOME/.xprofile"
# fi

# dwm window manager
# ssh-agent dwm

# gnome desktop environment
#export XDG_SESSION=x11
#export GDK_BACKEND=x11
#exec gnome-session

# xmonad window manager
# ssh-agent xmonad

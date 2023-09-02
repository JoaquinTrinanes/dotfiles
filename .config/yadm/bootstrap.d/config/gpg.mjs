#!/usr/bin/env zx

await $`cp /etc/xdg/autostart/gnome-keyring-ssh.desktop ~/.config/autostart/gnome-keyring-ssh.desktop`;
await $`echo 'Hidden=true' >> ~/.config/autostart/gnome-keyring-ssh.desktop`;

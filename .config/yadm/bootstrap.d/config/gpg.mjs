#!/usr/bin/env zx

const entryPath = "/etc/xdg/autostart/gnome-keyring-ssh.desktop";
if (!fs.existsSync(entryPath)) {
  process.exit();
}

await $`cp ${entryPath} ~/.config/autostart/gnome-keyring-ssh.desktop`;
await $`echo 'Hidden=true' >> ~/.config/autostart/gnome-keyring-ssh.desktop`;

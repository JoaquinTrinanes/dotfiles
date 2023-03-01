#!/usr/bin/env -S zx --experimental

const user = process.env.USER;

await $`sudo gpasswd -a ${user} lp`;

#!/usr/bin/env -S zx --experimental

import { packages } from "../utils/packages.mjs";

const user = process.env.USER;

for await (const group of packages.groups) {
  await $`sudo gpasswd -a ${user} ${group}`;
}

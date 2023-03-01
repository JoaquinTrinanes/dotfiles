#!/usr/bin/env -S zx --experimental

import { commandExists } from "../utils/commands.mjs";

if (await commandExists("lvim")) {
  process.exit();
}

await $`curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh | sh`;

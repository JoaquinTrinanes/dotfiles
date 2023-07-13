#!/usr/bin/env -S zx --experimental

import { commandExists } from "../utils/commands.mjs";

if (!fs.existsSync("/nix")) {
  await $`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix`.pipe(
    $`sh -s -- install`
  );
}

if (commandExists("home-manager")) {
  process.exit();
}

await $`nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`;
await $`nix-channel --update`;
await $`nix-shell '<home-manager>' -A install`;

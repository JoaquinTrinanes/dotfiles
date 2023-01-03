#!/usr/bin/env zx --experimental

import * as log from "./utils/log.mjs";

await spinner(
  "Installing neovim plugins...",
  () => $`nvim --headless +PackerInstall +qall!`
);
log.ok("Installed neovim plugins");

#!/usr/bin/env -S zx --experimental

import { commandExists } from "./utils/commands.mjs";
import * as log from "./utils/log.mjs";

if (!(await commandExists("rustup"))) {
  await $`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path`;
} else {
  log.info("rustup already exists. Skipping");
}

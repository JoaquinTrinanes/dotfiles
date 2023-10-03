#!/usr/bin/env -S zx --experimental

import { createMacConfigSymlink } from "../utils/os.mjs";
import { commandExists } from "../utils/commands.mjs";
import * as log from "../utils/log.mjs";

if (!commandExists("flavours")) {
  log.warn("Flavours binary not found, skipping setup");
  process.exit();
}

const DEFAULT_THEME = "catppuccin-frappe";

process.env.PATH = `${path.join(os.homedir(), ".cargo/bin")}:${
  process.env.PATH
}`;

createMacConfigSymlink("flavours");

await $`flavours update all`.nothrow();

try {
  await $`flavours current`.quiet();
} catch (e) {
  log.info(
    `No flavours theme detected. Applying default ${DEFAULT_THEME} theme`,
  );
  await $`flavours apply ${DEFAULT_THEME}`;
}

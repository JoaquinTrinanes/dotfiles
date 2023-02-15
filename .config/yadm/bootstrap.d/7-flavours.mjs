#!/usr/bin/env -S zx --experimental

import { createMacConfigSymlink } from "./utils/os.mjs";
import * as log from "./utils/log.mjs";

const DEFAULT_THEME = "nord";

createMacConfigSymlink("flavours");

await $`flavours update all`;

try {
  await $`flavours current`.quiet();
} catch (e) {
  log.info(
    `No flavours theme detected. Applying default ${DEFAULT_THEME} theme`
  );
  await $`flavours apply ${DEFAULT_THEME}`;
}

#!/usr/bin/env -S zx --experimental

import { IS_MAC } from "./utils/os.mjs";
import * as log from "./utils/log.mjs";

const DEFAULT_THEME = "nord";

const macFlavoursConfigPath = path.join(
  os.homedir(),
  "Library/Preferences/flavours"
);

const configFileExists = fs.existsSync(macFlavoursConfigPath);

if (IS_MAC && !configFileExists) {
  await $`ln -s ${path.join(
    os.homedir(),
    ".config/flavours"
  )} ${flavoursConfigPath}`;
}

await $`flavours update all`;

try {
  await $`flavours current`.quiet();
} catch (e) {
  log.info(
    `No flavours theme detected. Applying default ${DEFAULT_THEME} theme`
  );
  await $`flavours apply ${DEFAULT_THEME}`;
}
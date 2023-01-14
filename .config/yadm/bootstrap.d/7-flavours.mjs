#!/usr/bin/env -S zx --experimental

import { IS_MAC } from "./utils/os.mjs";
import * as log from "./utils/log.mjs";

const DEFAULT_THEME = "nord";

const fileExists = (path) =>
  $`ls ${path}`
    .quiet()
    .then(() => true)
    .catch(() => false);

const macFlavoursConfigPath = path.join(
  os.homedir(),
  "Library/Preferences/flavours"
);

const configFileExists = await fileExists(macFlavoursConfigPath);

if (IS_MAC && !configFileExists) {
  await $`ln -s ${path.join(
    os.homedir(),
    ".config/flavours"
  )} ${flavoursConfigPath}`;
}

try {
  await $`flavours current`.quiet();
} catch (e) {
  log.info(
    `No flavours theme detected. Applying default ${DEFAULT_THEME} theme`
  );
  await $`flavours apply ${DEFAULT_THEME}`;
}

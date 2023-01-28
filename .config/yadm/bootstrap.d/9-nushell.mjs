#!/usr/bin/env -S zx --experimental

import { IS_MAC } from "./utils/os.mjs";

if (!IS_MAC) {
  process.exit();
}
const macConfigPath = path.join(
  os.homedir(),
  "Library/Application Support/nushell"
);

const targetConfigPath = path.join(os.homedir(), ".config/nushell");

await $`rm -rf ${macConfigPath}`;
await $`ln -s -F ${targetConfigPath} ${macConfigPath}`;

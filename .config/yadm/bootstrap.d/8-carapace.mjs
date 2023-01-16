#!/usr/bin/env -S zx --experimental

import { IS_MAC } from "./utils/os.mjs";

if (!IS_MAC) {
  process.exit();
}
const macConfigPath = path.join(
  os.homedir(),
  "Library/Application Support/carapace"
);

const targetConfigPath = path.join(os.homedir(), ".config/carapace");

await $`rm -rf ${macConfigPath}`;
await $`ln -s -F ${targetConfigPath} ${macConfigPath}`;

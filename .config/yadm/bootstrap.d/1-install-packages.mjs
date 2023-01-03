#!/usr/bin/env -S zx --experimental

import * as log from "./utils/log.mjs";
import { IS_MAC } from "./utils/os.mjs";
import { commandExists } from "./utils/commands.mjs";
import { packageManager } from "./utils/package-manager.mjs";

const packages = await fs.readJson(
  path.join(__dirname, "../packagesToInstall.json")
);

await packageManager.init();

for (const pkg of packages) {
  await packageManager.installPackageIfMissing(pkg);
}

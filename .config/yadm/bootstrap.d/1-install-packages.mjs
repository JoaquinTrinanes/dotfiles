#!/usr/bin/env -S zx --experimental

import { packageManager, PackageDefinition } from "./utils/package-manager.mjs";
import { packages } from "./utils/packages.mjs";

await packageManager.install(
  packages.packages.map((p) => new PackageDefinition(p)),
  { skipInstalled: true }
);

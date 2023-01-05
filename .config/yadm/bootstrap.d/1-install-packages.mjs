#!/usr/bin/env -S zx --experimental

import { packageManager, PackageDefinition } from "./utils/package-manager.mjs";

const packageInfo = YAML.parse(
  fs.readFileSync(path.join(__dirname, "../packages.yaml"), "utf-8")
);

await packageManager.init();

for (const pkg of packageInfo.packages) {
  const pkgDefinition = new PackageDefinition(pkg);
  await packageManager.installPackageIfMissing(pkgDefinition);
}

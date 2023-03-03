#!/usr/bin/env -S zx --experimental

import { commandExists } from "../utils/commands.mjs";
import * as log from "../utils/log.mjs";
import { packages } from "../utils/packages.mjs";

process.env.PATH = `${path.join(os.homedir(), ".cargo/bin")}:${
  process.env.PATH
}`;

if (!commandExists("rustup")) {
  await $`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path`;
  await $`rustup default stable`;
} else {
  log.info("rustup already exists. Skipping");
}

const packagesWithoutFeatures = packages.cargo.filter(
  (p) => typeof p === "string"
);
const packagesWithFeatures = packages.cargo.filter(
  (p) => typeof p !== "string"
);

await $`cargo install ${packagesWithoutFeatures}`;
for (const p of packagesWithFeatures) {
  const [name, { features }] = Object.entries(p)[0];
  await $`cargo install ${name} --features ${features}`;
}

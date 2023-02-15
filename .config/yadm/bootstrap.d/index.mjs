#!/usr/bin/env -S zx --experimental

process.env.FORCE_COLOR = "1";

await within(async () => {
  cd(__dirname);
  const dependencyFiles = await glob("dependencies/*.mjs");
  for (const f of dependencyFiles) {
    await $`${f}`;
  }
  const configFiles = await glob(["config/*.mjs"]);
  for (const f of configFiles) {
    await $`./${f}`;
  }
});

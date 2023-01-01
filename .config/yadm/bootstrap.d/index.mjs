#!/usr/bin/env -S zx --experimental

process.env.FORCE_COLOR = "1";

await within(async () => {
  cd(__dirname);
  const files = await glob(["[0-9]*.mjs"]);
  for (const f of files) {
    log(`Executing ${f}`);
    await $`./${f}`;
  }
});

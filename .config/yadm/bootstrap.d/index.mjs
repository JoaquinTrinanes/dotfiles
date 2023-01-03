#!/usr/bin/env -S zx --experimental

process.env.FORCE_COLOR = "1";

import * as log from "./utils/log.mjs";

await within(async () => {
  cd(__dirname);
  const files = await glob(["[0-9]*.mjs"]);
  for (const f of files) {
    await $`./${f}`;
  }
});

#!/usr/bin/env -S zx --experimental

import { packages } from "../utils/packages.mjs";

if (packages.length > 0) {
  await $`pip install --user ${packages.pip}`;
}

#!/usr/bin/env -S zx --experimental

import { packages } from "./utils/packages.mjs";

await $`pip install --user ${packages.pip}`;

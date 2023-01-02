#!/usr/bin/env zx --experimental

import { commandExists } from "./utils/commands.mjs";

if (!(await commandExists("fisher"))) {
  await `curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher`;
}

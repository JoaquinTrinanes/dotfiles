#!/usr/bin/env zx

import * as log from "./log.mjs";

const REMOTE_URL = "git@github.com:JoaquinTrinanes/dotfiles.git";
const currentUrl = (await $`yadm remote get-url origin`.quiet()).stdout.trim();

if (currentUrl !== REMOTE_URL) {
  await $`yadm remote set-url origin "git@github.com:JoaquinTrinanes/dotfiles.git"`;
  log.ok(`Updated yadm remote url to ${REMOTE_URL}`);
}

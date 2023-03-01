#!/usr/bin/env -S zx --experimental

import * as log from "../utils/log.mjs";
import { IS_MAC } from "../utils/os.mjs";
import { commandExists } from "../utils/commands.mjs";
import { packages } from "../utils/packages.mjs";

const brewInstalled = await commandExists("brew");

const installPacaptr = async () => $`brew install pacaptr`;

const installBrew = async () => {
  await $`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`;
};

const installYay = async () => {
  const tmpDir = (await $`mktemp -d`.quiet()).stdout.trim();

  await within(async () => {
    cd(tmpDir);
    await $`git clone https://aur.archlinux.org/yay.git ${tmpDir}`;
    await $`makepkg -si --noconfirm`;
  });
};

const PACKAGE_MANAGERS = ["yay", "brew"];

let isManagerInstalled = false;
for await (const mgr of PACKAGE_MANAGERS) {
  if (await commandExists(mgr)) {
    isManagerInstalled = true;
    break;
  }
}

if (isManagerInstalled) {
  log.info("Package manager is already installed. Skipping.");
} else {
  if (IS_MAC) {
    await spinner("Installing brew...", () => installBrew());
    log.ok(`Installed ${chalk.yellow("brew")}!`);
  } else {
    log.info("Installing yay...");
    await installYay();
    log.ok(`Installed ${chalk.yellow("yay")}!`);
  }
}

if (brewInstalled) {
  for (const tap of packages?.brew?.taps || []) {
    await spinner(`brew tap ${tap}`, () => $`brew tap ${tap}`.quiet());
  }
}

if (!(await commandExists("pacman")) && !(await commandExists("pacaptr"))) {
  await installPacaptr();
}

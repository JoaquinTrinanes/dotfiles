#!/usr/bin/env -S zx

import * as log from "./log.mjs";

const installBrew = async () => {
  await $`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`;
};

const installYay = async () => {
  const tmpDir = (await $`mktemp -d`.quiet()).stdout.trim();

  await within(async () => {
    cd(tmpDir);
    await $`git clone https://aur.archlinux.org/yay.git ${tmpDir}`;
    await $`makepkg -si`;
  });
};

const PACKAGE_MANAGERS = ["yay", "brew"];

const isManagerInstalled =
  (await $`command -v ${PACKAGE_MANAGERS}`.quiet()).exitCode === 0;

if (isManagerInstalled) {
  log.debug("Package manager is already installed. Skipping.");
} else {
  if ((await $`uname -s`).stdout.trim() === "Darwin") {
    await spinner("Installing brew...", () => installBrew());
    log.ok(`Installed ${chalk.yellow("brew")}!`);
  } else {
    await spinner("Installing yay...", () => installYay());
    log.ok(`Installed ${chalk.yellow("yay")}!`);
  }
}

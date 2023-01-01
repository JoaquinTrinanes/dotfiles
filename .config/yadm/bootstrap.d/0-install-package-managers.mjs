#!/usr/bin/env zx

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

if (!isManagerInstalled) {
  if ((await $`uname -s`).stdout.trim() === "Darwin") {
    await installBrew();
  } else {
    await installYay();
  }
}

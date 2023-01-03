#!/usr/bin/env -S zx --experimental

import * as log from "./utils/log.mjs";
import { IS_MAC } from "./utils/os.mjs";

const packages = await fs.readJson(
  path.join(__dirname, "../packagesToInstall.json")
);

const commandExists = (cmd) =>
  $`command -v ${cmd}`
    .quiet()
    .then(() => true)
    .catch(() => false);

class PackageManager {
  static PACKAGE_MANAGERS = {
    yay: { list: "yay  -Q", install: "yay --noprogressbar --noconfirm -S" },
    pacman: {
      list: "pacman -Q ",
      install: "sudo pacman --noprogressbar --noconfirm -S",
    },
    "apt-get": {
      list: "apt-get -qq list --installed",
      install: "sudo apt-get -qq --yes install",
    },
    brew: { list: "brew list --quiet -1", install: "brew install --quiet" },
  };

  static async getCurrentPackageManagerName() {
    for (const manager of Object.keys(this.PACKAGE_MANAGERS)) {
      if (await commandExists(manager)) {
        return manager;
      }
    }
  }

  #current;

  async installPackage(pkg) {
    await $`${this.#current.install.split(" ")} ${pkg}`;
  }

  async isPackageInstalled(pkgDefinition) {
    const name = this.getPackageName(pkgDefinition);
    try {
      await $`${this.#current.list.split(" ")} ${name}`.quiet();
      return true;
    } catch (_e) {
      if (pkgDefinition.font) return false;
      return await commandExists(pkgDefinition.bin || name);
    }
  }

  getPackageName(pkgDefinition) {
    if (typeof pkgDefinition === "string") return pkgDefinition;

    if (IS_MAC && "mac" in pkgDefinition) return pkgDefinition.mac;

    if (!IS_MAC && "linux" in pkgDefinition) return pkgDefinition.linux;

    return pkgDefinition.name;
  }

  async installPackageIfMissing(pkgDefinition) {
    const name = this.getPackageName(pkgDefinition);
    if (!name) return;

    const isInstalled = await spinner(
      `Checking if ${name} is installed...`,
      () => this.isPackageInstalled(pkgDefinition)
    );

    if (isInstalled) {
      log.debug(
        `${chalk.yellow(
          pkgDefinition.name ||
            pkgDefinition.mac ||
            pkgDefinition.linux ||
            pkgDefinition
        )} already installed. Skipping.`
      );
      return;
    }

    try {
      await spinner(`Installing ${chalk.yellow(name)}`, () =>
        this.installPackage(name)
      );
      log.ok(`Installed ${chalk.yellow(name)}! 🎉`);
    } catch (_e) {
      log.error(`Error installing ${chalk.yellow(name)}`);
    }
  }

  constructor(pkgManager) {
    this.#current = PackageManager.PACKAGE_MANAGERS[pkgManager];
    if (!this.#current) {
      throw new Error(
        `No supported package manager found. Got: ${pkgManager}, valid options are: ${JSON.stringify(
          Object.keys(PackageManager.PACKAGE_MANAGERS)
        )}`
      );
    }
  }
}

const packageManager = new PackageManager(
  await PackageManager.getCurrentPackageManagerName()
);

for (const pkg of packages) {
  await packageManager.installPackageIfMissing(pkg);
}

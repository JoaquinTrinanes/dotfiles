#!/usr/bin/env -S zx --experimental

import * as log from "./log.mjs";
import { IS_MAC } from "./os.mjs";
import { commandExists } from "./commands.mjs";

const taps = await within(async () => {
  cd(__dirname);
  return (await fs.readJson("../packagesToInstall.json"))?.homebrew.taps;
});

const PACKAGE_MANAGERS = {
  yay: {
    list: ["yay", "-Q"],
    install: ["yay", "--noprogressbar", "--noconfirm", "-S"],
    upgrade: ["yay", "-Syu"],
  },
  pacman: {
    list: ["pacman", "-Q"],
    install: [
      "sudo",
      "pacman",
      "--noprogressbar",
      "--noconfirm",
      "--needed",
      "-S",
    ],
    upgrade: ["sudo", "pacman", "-Syu"],
  },
  "apt-get": {
    init: ["sudo", "apt-get", "update"],
    list: ["apt-get", "-qq", "list", "--installed"],
    upgrade: ["sudo", "apt-get", "-qq", "--yes", "upgrade"],
    install: ["sudo", "apt-get", "-qq", "--yes", "install"],
  },
  brew: {
    list: ["brew", "list", "--quiet", "-1"],
    install: ["brew", "install", "--quiet"],
    upgrade: ["brew", "upgrade"],
    init: taps.map((t) => ["brew", "tap", t]),
  },
};

const getCurrentPackageManager = async () => {
  for (const [name, manager] of Object.entries(PACKAGE_MANAGERS)) {
    if (await commandExists(name)) {
      return manager;
    }
  }
};

export class PackageManager {
  #current;

  async #runCommand(cmd) {
    const commandList = Array.isArray(cmd) ? cmd : [cmd];
    for (const c of commandList) {
      await spinner(c.join(" "), () => $`${c}`);
    }
  }

  async installPackage(pkg) {
    await within(async () => {
      $.prefix = "HOMEBREW_NO_AUTO_UPDATE=1;";
      await $`${this.#current.install} ${pkg}`;
    });
  }

  async isPackageInstalled(pkgDefinition) {
    const name = this.getPackageName(pkgDefinition);
    try {
      await $`${this.#current.list} ${name}`.quiet();
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

  async upgrade() {
    if (!this.#current.upgrade) {
      throw new Error("Upgrade command not defined");
    }
    await this.#runCommand(this.#current.upgrade);
  }

  async init() {
    if (this.#current.init) {
      await this.#runCommand(this.#current.init);
    }
  }

  constructor(pkgManager) {
    if (!pkgManager || !pkgManager.install || !pkgManager.list) {
      throw new Error(
        "Invalid package manager, it needs at least an 'install' and 'list' field"
      );
    }
    this.#current = Object.fromEntries(
      Object.entries(pkgManager).map(([k, v]) => [
        k,
        Array.isArray(v) ? v : v.split(" "),
      ])
    );
  }
}

export const packageManager = new PackageManager(
  await getCurrentPackageManager()
);

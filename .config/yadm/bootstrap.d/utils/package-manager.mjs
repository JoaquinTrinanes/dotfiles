#!/usr/bin/env -S zx --experimental

import * as log from "./log.mjs";
import { commandExists } from "./commands.mjs";

const taps = await within(async () => {
  cd(__dirname);
  const fileContents = fs.readFileSync("../packages.yaml", "utf-8");
  const packages = YAML.parse(fileContents);
  return packages?.homebrew.taps || [];
});

const PACKAGE_MANAGERS = {
  yay: {
    list: ["-Q"],
    install: ["--noprogressbar", "--noconfirm", "-S"],
    upgrade: ["-Syu"],
  },
  pacman: {
    list: ["-Q"],
    install: ["--noprogressbar", "--noconfirm", "--needed", "-S"],
    upgrade: ["-Syu"],
    sudo: true,
  },
  "apt-get": {
    init: ["update"],
    list: ["list", "--installed"],
    upgrade: ["-qq", "--yes", "upgrade"],
    install: ["-qq", "--yes", "install"],
    sudo: true,
  },
  brew: {
    list: ["list", "--quiet", "-1"],
    install: ["install", "--quiet"],
    upgrade: ["upgrade"],
    init: taps.map((t) => ["tap", t]),
  },
};

const getCurrentPackageManager = async () => {
  for (const [name, manager] of Object.entries(PACKAGE_MANAGERS)) {
    if (await commandExists(name)) {
      return { name, ...manager };
    }
  }
};

export class PackageDefinition {
  name;
  bin;
  overrides;

  static #getPackageDefinition(pkg) {
    if (typeof pkg === "string") return { name: pkg };

    const [name, options] = Object.entries(pkg)[0];
    return { name, ...options };
  }

  constructor(def) {
    const { name, bin, ...rest } = PackageDefinition.#getPackageDefinition(def);
    this.name = name;
    this.bin = bin;
    this.overrides = rest;
  }

  getField(field) {
    return this.overrides[field];
  }

  getFieldOrName(field) {
    if (field in this.overrides) return this.getField(field);
    return this.name;
  }
}

export class PackageManager {
  current;

  async runCommand(cmd) {
    const commandList = Array.isArray(cmd[0]) ? cmd : [cmd];
    for (const c of commandList) {
      const command = [
        ...(this.current.sudo ? ["sudo"] : []),
        this.current.name,
        ...(Array.isArray(c) ? c : [c]),
      ];
      await spinner(command.join(" "), () => $`${command}`);
    }
  }

  async installPackage(pkg) {
    await this.runCommand([...this.current.install, pkg]);
  }

  async isPackageInstalled(pkg) {
    const name = pkg.getFieldOrName(this.current.name);
    try {
      await this.runCommand([...this.current.list, name]);
      return true;
    } catch (_e) {
      if (pkg.getField("font")) return false;
      return await commandExists(pkg.bin || name);
    }
  }

  async installPackageIfMissing(pkg) {
    const name = pkg.getFieldOrName(this.current.name);
    if (!name) return;

    const isInstalled = await spinner(
      `Checking if ${name} is installed...`,
      () => this.isPackageInstalled(pkg)
    );

    if (isInstalled) {
      log.debug(`${chalk.yellow(name)} already installed. Skipping.`);
      return;
    }

    try {
      await spinner(`Installing ${chalk.yellow(name)}`, () =>
        this.installPackage(name)
      );
      log.ok(`Installed ${chalk.yellow(name)}! 🎉`);
    } catch (e) {
      log.error(`Error installing ${chalk.yellow(name)}`);
      log.error("\t" + e.toString());
    }
  }

  async upgrade() {
    if (!this.current.upgrade) {
      throw new Error("Upgrade command not defined");
    }
    await this.runCommand(this.current.upgrade);
  }

  async init() {
    if (this.current.init) {
      await this.runCommand(this.current.init);
    }
  }

  constructor(pkgManager) {
    if (!pkgManager || !pkgManager.install || !pkgManager.list) {
      throw new Error(
        "Invalid package manager, it needs at least an 'install' and 'list' field"
      );
    }
    this.current = pkgManager;
  }
}

export const packageManager = new PackageManager(
  await getCurrentPackageManager()
);

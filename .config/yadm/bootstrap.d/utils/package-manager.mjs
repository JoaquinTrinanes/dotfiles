import { commandExists } from "./commands.mjs";

const overrideName = (await commandExists("brew"))
  ? "brew"
  : (await commandExists("apt-get"))
  ? "apt-get"
  : (await commandExists("yay"))
  ? "yay"
  : "pacman";

export class PackageDefinition {
  #name;
  bin;
  overrides;
  alias;

  static #getPackageDefinition(pkg) {
    if (typeof pkg === "string") return { name: pkg };

    const [name, options] = Object.entries(pkg)[0];
    return { name, ...options };
  }

  constructor(def) {
    const { name, bin, alias, ...rest } =
      PackageDefinition.#getPackageDefinition(def);
    this.#name = name;
    this.bin = bin;
    this.alias = alias;
    this.overrides = rest;
  }

  getField(field, alias) {
    if (field in this.overrides) return this.overrides[field];
    if (!alias) return;

    return this.overrides[alias];
  }

  get name() {
    return this.getFieldOrName(overrideName, this.alias);
  }

  getFieldOrName(field, alias) {
    if (field in this.overrides || (alias && alias in this.overrides))
      return this.getField(field, alias);
    return this.#name;
  }
}

export class PackageManager {
  current;

  async #_install(pkgs, { skipInstalled = true, yes = true } = {}) {
    const flags = [];
    if (skipInstalled) flags.push("--needed");
    if (yes) flags.push("--noconfirm");
    await $`${this.current} -S ${flags} ${pkgs}`;
  }

  async install(pkg, opts) {
    const packageNames = (Array.isArray(pkg) ? pkg : [pkg])
      .map((p) => p.name)
      .filter(Boolean);
    return await this.#_install(packageNames, opts);
  }

  async isPackageInstalled(pkg) {
    const name = pkg.name;
    try {
      await $`${this.current} -Ql ${name}`.quiet();
      return true;
    } catch (_e) {
      return false;
    }
  }

  async upgrade() {
    await $`${this.current} -Syu --noconfirm`;
  }

  async init() {
    await $`${this.current} -Sy`;
  }

  constructor(pkgManager) {
    this.current = pkgManager;
  }
}

const getCommand = async () => {
  const possibleManagers = ["yay", "pacman", "pacaptr"];
  for (const mgr of possibleManagers) {
    if (await commandExists(mgr)) return mgr;
  }
};

const command = await getCommand();
export const packageManager = new PackageManager(command);

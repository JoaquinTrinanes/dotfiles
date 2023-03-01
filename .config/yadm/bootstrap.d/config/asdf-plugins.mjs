#!/usr/bin/env -S zx --experimental

import { commandExists } from "../utils/commands.mjs";
import * as log from "../utils/log.mjs";

process.env.PATH = `/opt/asdf-vm/bin:${process.env.PATH}`;

if (!(await commandExists("asdf"))) {
  log.error("asdf not found");
  process.exit(0);
}

const installAsdfPlugin = async (plugin, version) => {
  await $`asdf plugin add ${plugin}`;
  if (version) {
    await $`asdf install ${plugin} ${version}`;
    await $`asdf global ${plugin} ${version}`;
  } else {
    await $`asdf global ${plugin} system`;
  }
};

const installAsdfPluginIfMissing = async (plugin, version) => {
  const isInstalled = await $`asdf list`
    .quiet()
    .pipe($`grep ${plugin}`.quiet())
    .then(() => true)
    .catch(() => false);

  if (isInstalled) {
    log.info(
      `asdf plugin ${chalk.yellow(plugin)} already installed. Skipping.`
    );
    return;
  }
  await spinner(`Installing asdf plugin ${chalk.yellow(plugin)}`, () =>
    installAsdfPlugin(plugin, version)
  );
  log.ok(`Installed ${chalk.yellow(plugin)} asdf plugin`);
};

for (const [plugin, version] of [["nodejs"], ["direnv"]]) {
  await installAsdfPluginIfMissing(plugin, version);
}

await spinner("Reshiming asdf...", () => $`asdf reshim`);

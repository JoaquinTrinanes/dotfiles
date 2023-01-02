#!/usr/bin/env -S zx --experimental

import * as log from "./log.mjs";
const installAsdfPlugin = async (plugin, version) => {
  await $`asdf plugin add ${plugin}`;
  if (version) {
    await $`asdf install ${plugin} ${version}`;
    await $`asdf global ${plugin} ${version}`;
  }
};

const installAsdfPluginIfMissing = async (plugin, version) => {
  const isInstalled = await $`asdf list`
    .quiet()
    .pipe($`grep ${plugin}`.quiet())
    .then(() => true)
    .catch(() => false);

  if (isInstalled) {
    log.debug(
      `asdf plugin ${chalk.yellow(plugin)} already installed. Skipping.`
    );
    return;
  }
  await spinner(`Installing asdf plugin ${chalk.yellow(plugin)}`, () =>
    installAsdfPlugin(plugin, version)
  );
  log.ok(`Installed ${chalk.yellow(plugin)} asdf plugin`);
};

for (const [plugin, version] of [
  ["nodejs", "lts"],
  ["direnv", "system"],
]) {
  await installAsdfPluginIfMissing(plugin, version);
}

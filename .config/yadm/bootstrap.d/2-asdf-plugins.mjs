#!/usr/bin/env zx --experimental

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
    echo`asdf plugin ${chalk.yellow(plugin)} already installed. Skipping.`;
    return;
  }
  spinner(`Installing asdf plugin ${chalk.yellow(plugin)}`, () =>
    installAsdfPlugin(plugin, version)
  );
};

for (const [plugin, version] of [
  ["nodejs", "lts"],
  ["direnv", "system"],
]) {
  await installAsdfPluginIfMissing(plugin, version);
}

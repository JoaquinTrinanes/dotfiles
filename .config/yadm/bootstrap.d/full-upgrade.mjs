#!/usr/bin/env zx --experimental

import { packageManager } from "./utils/package-manager.mjs";
import * as log from "./utils/log.mjs";
import { commandExists } from "./utils/commands.mjs";

const updateOk = (data) => {
  log.ok(`Successfully updated ${chalk.yellow(data)}`);
};

await spinner("Upgrading system dependencies...", () =>
  packageManager.upgrade()
);
updateOk("system packages");

const antidotePath = path.join(
  os.homedir(),
  ".config/zsh/.antidote/antidote.zsh"
);
if (!fs.existsSync(antidotePath)) {
  log.warn("Antidote not found. Skipping update.");
} else {
  await within(async () => {
    $.shell = "/bin/zsh";
    $.prefix += `source ${antidotePath};`;
    await spinner("Updating antidote plugins...", () => $`antidote update`);
    updateOk("antidote and its plugins");
  });
}

await spinner("Upgrading asdf plugins...", () => $`asdf plugin update --all`);
updateOk("asdf plugins");

await spinner(
  "Upgrading NeoVim plugins...",
  () => $`nvim --headless +PackerSync +qall!`
);
updateOk("NeoVim plugins");

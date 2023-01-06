#!/usr/bin/env -S zx --experimental

import { packageManager } from "./utils/package-manager.mjs";
import * as log from "./utils/log.mjs";

const updateOk = (data) => {
  log.ok(`Successfully updated ${chalk.yellow(data)}`);
};

log.info("Upgrading system dependencies...");
await packageManager.upgrade();
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

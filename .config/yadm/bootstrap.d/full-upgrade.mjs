#!/usr/bin/env -S zx --experimental

import { packageManager } from "./utils/package-manager.mjs";
import * as log from "./utils/log.mjs";
import { commandExists } from "./utils/commands.mjs";

const updateOk = (data) => {
  log.ok(`Successfully updated ${chalk.yellow(data)}`);
};

log.info("Updating system dependencies...");
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

await spinner("Updating asdf plugins...", () => $`asdf plugin update --all`);
updateOk("asdf plugins");

await spinner(
  "Updating NeoVim plugins...",
  () => $`nvim --headless +PackerSync +qall!`
);
updateOk("NeoVim plugins");

if (await commandExists("rustup")) {
  await spinner("Updating rust via rustup", () => $`rustup update`);
  updateOk("rust");
} else {
  log.warn("rustup not found. Skipping update");
}

await spinner("Updating cargo crates...", () => $`cargo install-update --all`);
updateOk("cargo crates");

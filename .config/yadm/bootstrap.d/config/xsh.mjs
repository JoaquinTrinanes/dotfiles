#!/usr/bin/env -S zx --experimental

const xshConfigPath = path.join(os.homedir(), ".config", "xsh");

if (fs.existsSync(xshConfigPath)) {
  process.exit();
}

await $`git clone --depth=1 https://github.com/sgleizes/xsh ${xshConfigPath}`;

$.prefix = "set +u;";
await $`source ${xshConfigPath}/xsh.sh && xsh bootstrap --shells posix:bash:zsh`;

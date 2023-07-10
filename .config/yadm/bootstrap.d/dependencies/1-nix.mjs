#!/usr/bin/env -S zx --experimental

if (fs.existsSync("/nix")) {
  process.exit();
}

await $`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix`.pipe(
  $`sh -s -- install`
);

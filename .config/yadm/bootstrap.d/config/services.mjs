#!/usr/bin/env -S zx --experimental

const userServices = ["pueued"];

for await (const service of userServices) {
  await $`systemctl --user enable --now ${service}`;
}

#!/usr/bin/env -S zx --experimental

import { packages } from "../utils/packages.mjs";
import { enableService } from "../utils/services.mjs";

const userServices = packages.services.user;
const systemServices = packages.services.system;

for await (const service of userServices) {
  await enableService(service, { user: true, now: true });
}

for await (const service of systemServices) {
  await enableService(service, { user: false, now: true });
}

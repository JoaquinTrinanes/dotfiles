#!/usr/bin/env -S zx --experimental

import { enableService } from "../utils/services.mjs";

const userServices = ["pueued"];

for await (const service of userServices) {
  await enableService(service, { user: true, now: true });
}

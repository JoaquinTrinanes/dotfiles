#!/usr/bin/env -S zx --experimental

import { enableService, disableService } from "../utils/services.mjs";

try {
  await disableService("pulseaudio", { user: true });
} catch (e) {}
await enableService("pipewire-pulse", { user: true });

#!/usr/bin/env -S zx --experimental

const buildCommand = ({ user = false, now = true } = {}) => {
  const command = ["systemctl"];
  if (user) {
    command.push("--user");
  } else {
    command.unshift("sudo");
  }
  if (now) {
    command.push("--now");
  }
  return command;
};

export const enableService = (serviceName, opts) => {
  const command = buildCommand(opts);
  return $`${command} enable ${serviceName}`;
};

export const disableService = (serviceName, opts) => {
  const command = buildCommand(opts);
  return $`${command} disable ${serviceName}`;
};

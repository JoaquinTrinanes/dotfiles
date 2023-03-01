#!/usr/bin/env -S zx --experimental

const buildCommandArgs = ({ user = false, now = true } = {}) => {
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

const buildCommand = (command, service, opts) => {
  const args = buildCommandArgs(opts);
  return [...args, command, service];
};

export const enableService = (serviceName, opts) => {
  return $`${buildCommand("enable", serviceName, opts)}`;
};

export const disableService = (serviceName, opts) => {
  return $`${buildCommand("disable", serviceName, opts)}`;
};

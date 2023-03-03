export const commandExists = (cmd) => {
  return !!which.sync(cmd, { nothrow: true });
};

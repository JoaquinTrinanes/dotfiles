export const commandExists = (cmd) =>
  $`command -v ${cmd}`
//    .quiet()
    .then(() => true)
    .catch(() => false);

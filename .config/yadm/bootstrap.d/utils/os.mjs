export const is = async (os) => {
  const currentOs = (await $`uname -s`.quiet()).stdout.trim();
  return os === currentOs;
};

export const IS_MAC = await is("Darwin");

const configPath = path.join(os.homedir(), ".config");
const macConfigPath = path.join(os.homedir(), "Library/Application Support");

export const createMacConfigSymlink = async (folder) => {
  if (!IS_MAC) {
    return;
  }
  const configFolder = path.join(configPath, folder);
  const targetFolder = path.join(macConfigPath, folder);
  await $`rm -rf ${targetFolder}`;
  await $`ln -s -F ${configFolder} ${targetFolder}`;
};

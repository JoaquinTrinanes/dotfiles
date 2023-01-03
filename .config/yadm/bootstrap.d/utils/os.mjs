#!/usr/bin/env zx

export const is = async (os) => {
  const currentOs = (await $`uname -s`.quiet()).stdout.trim();
  return os === currentOs;
};

export const IS_MAC = await is("Darwin");

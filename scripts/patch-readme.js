const mkReplace = (name, arg) => (patch) =>
  `<!-- START ${name} ${arg} -->\n${patch}\n<!-- END ${name} -->`;

export const patchAll = (patchData) => (source) => {
  const regex = new RegExp(
    `<!-- START ([a-zA-Z0-9_]+)(.*?)-->([\\s\\S]*?)<!-- END ([a-zA-Z0-9_]+) -->`,
    "g"
  );

  const newSource = source.replace(
    regex,
    (_, nameOpen, arg_, content, nameClose) => {
      if (nameOpen !== nameClose) {
        throw new Error(
          `Mismatched open/close name: '${nameOpen}' is not '${nameClose}'`
        );
      }
      const name = nameOpen;

      const patch = patchData[name];

      if (typeof patch === "undefined") {
        throw new Error(`No patch for '${name}'`);
      }

      const arg = arg_.trim();

      const newContent =
        typeof patch === "function" ? patch(content, arg) : patch;

      return mkReplace(name, arg)(newContent);
    }
  );

  return newSource;
};

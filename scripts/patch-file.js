export const langs = {
  md: { open: "<!--", close: "-->" },
  purs: { open: "{-", close: "-}" },
};

const mkReplace =
  ({ open, close }) =>
  (name, arg) =>
  (patch) => {
    const arg_ = arg === "" ? "" : ` ${arg}`;
    return `${open} START ${name}${arg_} ${close}${patch}${open} END ${name} ${close}`;
  };

const mkRegex = ({ open, close }) => {
  return new RegExp(
    `${open} START ([a-zA-Z0-9_]+)(.*?)${close}([\\s\\S]*?)${open} END ([a-zA-Z0-9_]+) ${close}`,
    "g"
  );
};

export const patchAll = (lang) => (patchData) => (source) => {
  const regex = mkRegex(lang);

  let newSource = source;

  newSource = source.replace(
    regex,
    (match, nameOpen, arg_, content, nameClose, index, all) => {
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

      const getNewContent = (patch_) =>
        typeof patch_ === "function"
          ? patch_(content, arg, index, all)
          : typeof patch_ === "string"
          ? patch
          : content;

      const newContent = getNewContent(patch);

      return mkReplace(lang)(name, arg)(newContent);
    }
  );

  const regexPatches = Object.values(patchData).filter((val) =>
    Array.isArray(val)
  );

  for (const [regex, patch] of regexPatches) {
    newSource = source.replace(regex, (...args) => {
      const newContent =
        typeof patch === "function"
          ? patch(...args)
          : typeof patch_ === "string"
          ? patch
          : (() => {
              throw new Error("unsupported patch");
            })();

      return newContent;
    });
  }

  return newSource;
};

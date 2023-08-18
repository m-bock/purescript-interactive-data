const patchSection = (name, patch) => (source) => {
  const regex = mkRegex(name);
  const replace = (_, content) => {
    const newContent = typeof patch === "function" ? patch(content) : patch;

    return mkReplace(name)(newContent);
  };

  return source.replace(regex, replace);
};

const mkRegex = (name) =>
  new RegExp(`<!-- START ${name} -->([\\s\\S]*)<!-- END ${name} -->`, "g");

const mkReplace = (name) => (patch) =>
  `<!-- START ${name} -->\n${patch}\n<!-- END ${name} -->`;

export const patchAll = (patchData) => (source_) => {
  let source = source_;
  for (const [name, patch] of Object.entries(patchData)) {
    source = patchSection(name, patch)(source);
  }
  return source;
};

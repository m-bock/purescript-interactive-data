const patchSection = (name, patch) => (source) => {
  const regex = mkRegex(name);
  const replace = mkReplace(name)(patch);

  return source.replace(regex, replace);
};

const mkRegex = (name) =>
  new RegExp(`<!-- START ${name} -->[\\s\\S]*<!-- END ${name} -->`, "g");

const mkReplace = (name) => (patch) =>
  `<!-- START ${name} -->\n${patch.trim()}\n<!-- END ${name} -->`;

export const patchAll = (patchData) => (source_) => {
  let source = source_;
  for (const [name, patch] of Object.entries(patchData)) {
    source = patchSection(name, patch)(source);
  }
  return source;
};

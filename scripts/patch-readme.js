import * as fs from "fs";
import * as cp from "child_process";

const source = fs.readFileSync("./README.md", "utf8").toString();

// const x = cp.spawnSync('purs-to-md', ['--input-purs', '' , '--output-md', '-']).stdout.toString().trim();

const patch = fs
  .readFileSync("./demo/src/Demo/Samples/MinimalComplete.purs", "utf8")
  .toString().replace(/module [A-Za-z.]*/g, 'module Main');

const patchSection = (name, patch) => (source) => {
  const regex = mkRegex(name);
  const replace = mkReplace(name)(patch);

  return source.replace(regex, replace);
};

const mkRegex = (name) =>
  new RegExp(`<!-- START ${name} -->[\\s\\S]*<!-- END ${name} -->`, "g");

const mkReplace = (name) => (patch) =>
  `<!-- START ${name} -->\n${patch}\n<!-- END ${name} -->`;

const codeBlock = (code) => `\`\`\`hs\n${code}\n\`\`\``;

const patchAll = (patchData) => (source_) => {
  let source = source_;
  for (const [name, patch] of Object.entries(patchData)) {
    source = patchSection(name, patch)(source);
  }
  return source;
};

//

const patchData = {
  demo: codeBlock(patch),
  details: "foo",
};

const result = patchAll(patchData)(source);

fs.writeFileSync("./README.md", result, "utf8");

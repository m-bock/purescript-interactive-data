import * as fs from "fs";
import * as cp from "child_process";

const source = fs.readFileSync("./README.md", "utf8").toString();

// const x = cp.spawnSync('purs-to-md', ['--input-purs', '' , '--output-md', '-']).stdout.toString().trim();

const patch = fs
  .readFileSync("./demo/src/Demo/Samples/MinimalComplete.purs", "utf8")
  .toString();

const mkRegex = (name) =>
  new RegExp(`<!-- START ${name} -->[\\s\\S]*<!-- END ${name} -->`, "g");
const mkReplace = (name) => (patch) =>
  `<!-- START ${name} -->\n${patch}\n<!-- END ${name} -->`;

const codeBlock = (code) => `\`\`\`hs\n${code}\n\`\`\``;

const result = source.replace(mkRegex("demo"), mkReplace("demo")(codeBlock(patch)));

fs.writeFileSync("./README.md", result, "utf8");

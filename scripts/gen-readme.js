import { patchAll } from "./patch-readme.js";
import * as fs from "fs";

const codeBlock = (path, lang, code) =>
  `
*${path}:*
\`\`\`${lang}\n${code.trim()}\n\`\`\`
`.trim();

const main = () => {
  const source = fs.readFileSync("./README.md", "utf8").toString();

  const patchData = {
    demoApp: codeBlock(
      "src/Main.purs",
      "hs",
      fs
        .readFileSync("./demo/src/Demo/Samples/MinimalComplete/Main.purs", "utf8")
        .toString()
        .replace(/module [A-Za-z.]*/g, "module Main")
    ),

    demoIndex: codeBlock(
      "static/index.js",
      "js",
      [`import { main } from "../output/Main/index.js";`, ``, `main();`].join(
        "\n"
      )
    ),

    demoHtml: codeBlock(
      "static/index.html",
      "html",
      fs.readFileSync("./demo/static/sample-minimal-complete/index.html", "utf8").toString()
    ),

    doctoc: (content) => content
  };

  const result = patchAll(patchData)(source);

  fs.writeFileSync("./README.md", result, "utf8");
};

main();

import { patchAll } from "./patch-readme.js";
import * as fs from "fs";

const filePath = process.argv[2]

const codeBlock = (path, lang, code) =>
  `
*${path}:*
\`\`\`${lang}\n${code.trim()}\n\`\`\`
`.trim();

const main = () => {
  const source = fs.readFileSync(filePath, "utf8").toString();

  const patchData = {
    hide: "",
    imports: (content) => `<details><summary>Imports for the code samples</summary>${content}</details><hr><br>`,
  };

  const result = patchAll(patchData)(source);

  fs.writeFileSync(filePath, result, "utf8");
};

main();

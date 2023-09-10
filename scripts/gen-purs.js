import { globSync } from "glob";
import { patchAll, langs } from "./patch-file.js";
import * as fs from "fs";
import * as prettier from "prettier";

const pursSrc = "packages/*/src";

const patch = patchAll(langs.purs)({
  moduleName: [
    /\n\nmoduleName :: String\nmoduleName = "[^"]+"\n\n/g,
    (match, index, fileSource) => {
      const res = fileSource.match(/module\s+(?<moduleName>[A-Za-z.]+)\s*/m);
      const { moduleName } = res.groups;

      return `

moduleName :: String
moduleName = "${moduleName}"

`;
    },
  ],

  multilineIndent: [
    /(declWith "[^"]*?"|css_?\)?|C\.(?:[a-z])+ \/\\)\n([ ]*?)(@?)"""([\s\S]*?)"""/g,
    async (match, cssFn, indent, at, innerStr) => {

      const innerStrNew = innerStr
        .split("\n")
        .map((x) => `${x.trim()}`)
        .join("\n");

      const innerStrNewFormatted = await prettier.format(innerStrNew, {
        parser: "css",
      });

      const result = innerStrNewFormatted.trim()
        .split("\n")
        .map((x) => `${indent}  ${x}`)
        .join("\n");

      return `${cssFn}\n${indent}${at}"""\n${result}\n${indent}"""`;
    },
  ],

  styleElems: [
    /el = styleElems([\s]*)"[^"]*"\n/g,
    (match, ws, index, fileSource) => {
      const res = fileSource.match(/module\s+(?<moduleName>[A-Za-z.]+)\s*/m);
      const { moduleName } = res.groups;
      const name = getClosestName(fileSource, index);

      return `el = styleElems${ws}"${moduleName}#${name}"\n`;
    },
  ],

  name: (content, arg, index, fileSource) => {
    const name = getClosestName(fileSource, index);
    return `  "#${name}" `;
  },

  scope: (content, arg, index, fileSource) => {
    const name = getClosestName(fileSource, index);
    const res = fileSource.match(/module\s+(?<moduleName>[A-Za-z.]+)\s*/m);
    const { moduleName } = res.groups;

    return ` "${moduleName}#${name}" `;
  },
});

const patchExtra = {
  'genModuleName = "([^"]*)"': "",
};

const getClosestName = (source, index) => {
  const lines = source.split("\n");

  let name = null;
  let curIndex = 0;

  for (const line of lines) {
    if (curIndex > index) {
      break;
    }

    const len = line.length + 1;
    if (!line.startsWith(" ")) {
      const result = line.match(/^([a-zA-Z0-9_']+)/);
      if (result) {
        name = result[1];
      }
    }

    curIndex += len;
  }

  return name;
};

const runFile = async (absFile) => {
  console.log(absFile);

  const source = fs.readFileSync(absFile, "utf8").toString();

  const result = await patch(source);

  fs.writeFileSync(absFile, result, "utf8");
};

const runAll = async () => {
  const manualFiles = globSync(`${pursSrc}/**/*.purs`);

  for (const file of manualFiles) {
    runFile(file);
  }
};

const main = async () => {
  await runAll();
};

main();

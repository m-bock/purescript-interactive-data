import * as fs from "fs";
import { patchAll } from "./patch-md.js";
import { embedKeys } from "../output/Demo.Samples.DocsEmbed.Main/index.js";

const codeBlock = (path, lang, code) =>
  `
*${path}:*
\`\`\`${lang}\n${code.trim()}\n\`\`\`
`.trim();

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
    fs
      .readFileSync("./demo/static/sample-minimal-complete/index.html", "utf8")
      .toString()
  ),

  doctoc: (content) => content,

  hide: "",

  removeType: (content) => content.replace(/type [^=]+= /g, ""),

  imports: (content) =>
    `<details><summary>Imports for the code samples</summary>${content}</details><hr><br>`,

  embed: (_, args) => {
    const [embedId, height_] = args.trim().split(" ");
    const embedExists = embedKeys.includes(embedId);
    if (!embedExists) {
      throw new Error(`No embed for '${embedId}'`);
    }

    const url = process.env.ID_URL_DEMO_EMBEDS;
    if (typeof url === "undefined") {
      throw new Error(`No 'ID_URL_DEMO_EMBEDS' defined`);
    }

    const urlManual = process.env.ID_URL_MANUAL;
    if (typeof urlManual === "undefined") {
      throw new Error(`No 'ID_URL_MANUAL' defined`);
    }

    const height = height_ || 315;

    const styleIframe = ["border: 0px"].join(";");

    const styleImg = [
      "width: 15px",
      "border: 1px solid #979797",
      "border-radius: 5px",
      "padding: 3px",
    ].join(";");

    return [
      `<div style="display:grid; grid-template-rows: auto minmax(0, 1fr); gap: 10px">`,
      `  <div style="display: flex; justify-content: flex-end">`,
      `    <a href="${url}?${embedId}">`,
      `      <img`,
      `        style="${styleImg}"`,
      `        title="Fullscreen"`,
      `        src="${urlManual}/assets/expand.svg"`,
      `        >`,
      `    </a>`,
      `  </div>`,
      `  <iframe `,
      `    allowtransparency="true"`,
      `    style="${styleIframe}"`,
      `    width="100%"`,
      `    height="${height}"`,
      `    src="${url}?${embedId}"`,
      `    >`,
      `  </iframe>`,
      `</div>`,
    ].join("\n");
  },

  asset: (content, args) => {
    const { label, url } = JSON.parse(args);
    const urlManual = process.env.ID_URL_MANUAL;
    const url_ = `${urlManual}/assets/${url}`;
    return `![${label}](${url_})`;
  },
};

export const idPatchMd = (source) => patchAll(patchData)(source);

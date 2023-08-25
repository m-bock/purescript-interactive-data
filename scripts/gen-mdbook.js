import { globSync } from "glob";
import * as fs from "fs";
import * as path from "path";
import { patchAll } from "./patch-readme.js";
import * as cp from "child_process";
import { program } from "commander";
import { embedKeys } from "../output/Demo.Samples.DocsEmbed.Main/index.js";

const pursSrc = "demo/src/Manual";
const mdDest = "mdbook/src/generated";

const runFile = async (absFile) => {
  console.log(absFile);
  const file = path.relative(pursSrc, absFile);

  const dir = path.dirname(file);

  fs.mkdirSync(path.join(mdDest, dir), { recursive: true });

  const md = await pursToMd(path.join(pursSrc, file));

  const mdPatched = postProcessFile(md);

  const fileParsed = path.parse(file);
  const mdFilePath = path.join(fileParsed.dir, fileParsed.name + ".md");

  fs.writeFileSync(path.join(mdDest, mdFilePath), mdPatched, "utf8");
};

const runAll = async () => {
  fs.rmSync(mdDest, { recursive: true, force: true });
  fs.mkdirSync(mdDest, { recursive: true });

  const manualFiles = globSync(`${pursSrc}/**/*.purs`);

  for (const file of manualFiles) {
    runFile(file);
  }
};

const postProcessFile = (source) => {
  const patchData = {
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
      const height = height_ || 315;
      const style = [
        "border:1px solid #cccccc",
        "border-radius: 5px",
        "margin-top: 10px",
        "margin-bottom: 10px",
      ].join(";");
      return `<iframe style="${style}" width="100%" height="${height}" src="${url}?${embedId}"></iframe>`;
    },
  };

  const result = patchAll(patchData)(source);

  return result;
};

const pursToMd = async (filePath) => {
  return runCommand("purs-to-md", ["--input-purs", filePath]);
};

const runCommand = async (command, args) => {
  const child = cp.spawn(command, args, { stdio: "pipe" });
  let stderr = "";
  let stdout = "";

  child.stderr.on("data", (data) => {
    stderr += data;
  });

  child.stdout.on("data", (data) => {
    stdout += data;
  });

  if (args.stdin) {
    child.stdin.write(args.stdin);
    child.stdin.end();
  }

  const exitCode = await new Promise((resolve, reject) => {
    child.on("exit", resolve);
  });

  if (exitCode !== 0) {
    throw new Error(`Subprocess error exit ${exitCode}, ${stderr}`);
  }

  return stdout;
};

const main = async () => {
  program.option("--file <string>");

  const opts = program.parse(process.argv).opts();

  if (opts.file) {
    await runFile(opts.file);
  } else {
    await runAll();
  }
};

main();

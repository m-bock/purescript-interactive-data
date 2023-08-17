import { globSync } from "glob";
import * as fs from "fs";
import * as path from "path";
import { patchAll } from "./patch-readme.js";
import * as cp from "child_process";

const pursSrc = "demo/src/Manual";
const mdDest = "mdbook/src/generated";

const main = async () => {
  fs.rmSync(mdDest, { recursive: true, force: true });
  fs.mkdirSync(mdDest, { recursive: true });

  const manualFiles = globSync(`**/*.purs`, { cwd: pursSrc });

  for (const file of manualFiles) {
    console.log(file);

    const dir = path.dirname(file);

    fs.mkdirSync(path.join(mdDest, dir), { recursive: true });

    const md = await pursToMd(path.join(pursSrc, file));

    const mdPatched = postProcessFile(md);

    const fileParsed = path.parse(file);
    const mdFilePath = path.join(fileParsed.dir, fileParsed.name + ".md");

    fs.writeFileSync(path.join(mdDest, mdFilePath), mdPatched, "utf8");
  }
};

const postProcessFile = (source) => {
  const patchData = {
    hide: "",
    imports: (content) =>
      `<details><summary>Imports for the code samples</summary>${content}</details><hr><br>`,
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

main();

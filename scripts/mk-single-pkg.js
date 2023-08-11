import { globSync } from "glob";
import yaml from "js-yaml";
import * as fs from "fs";
import * as cp from "child_process";
import * as path from "path";

const tgtRepoDir = "../purescript-interactive-data.all";

const githubRepo = {
  githubOwner: "thought2",
  githubRepo: "purescript-interactive-data.all",
};

const readmeTemplate = `
# purescript-interactive-data.all

This is a mirror of the package [purescript-interactive-data](https://github.com/thought2/purescript-interactive-data).
However, all local package from the source repo are merged into a single package.
This is due to the fact that publishing local packages from monorepos is currently not supported.
`.trim();

const gitignoreTemplate = `
/bower_components/
/node_modules/
/.pulp-cache/
/output/
/generated-docs/
/.psc-package/
/.psc*
/.purs*
/.psa*
/.spago
/.parcel-cache
/dist
`.trim();

const checkGitClean = (dir) => {
  const cmd = `git -C ${dir} status --porcelain`;
  const res = cp.execSync(cmd);
  return res.toString().trim() === "";
};

const readSpagoConfig = (file) => {
  const src = fs.readFileSync(file, "utf8");
  const spagoYaml = yaml.load(src);
  return spagoYaml;
};

const writeSpagoConfig = (file, spagoYaml) => {
  const src = yaml.dump(spagoYaml);
  fs.writeFileSync(file, src, "utf8");
};

const spagoEnsureRanges = (cwd) => {
  cp.execSync("spago fetch --ensure-ranges", { cwd });
};

const readVersion = () => {
  const content = fs.readFileSync("version.json", "utf8").toString();
  const json = JSON.parse(content);
  return { version: json.next, extra: json.extra };
};

const main = () => {
  const spagoYamlFiles = globSync("packages/**/*/spago.yaml");

  const gitCleanTgt = checkGitClean(tgtRepoDir);
  if (!gitCleanTgt) {
    console.error(`Git is not clean in ${tgtRepoDir}`);
    process.exit(1);
  }

  const gitCleanSrc = checkGitClean(".");
  if (!gitCleanSrc) {
    console.error(`Git is not clean in .`);
    process.exit(1);
  }

  fs.rmSync(path.join(tgtRepoDir, "src"), { recursive: true, force: true });

  const allDependencies = new Set();
  const localPackageNames = new Set();

  for (const file of spagoYamlFiles) {
    const dir = path.dirname(file);
    const spagoConfig = readSpagoConfig(file);
    const packageName = spagoConfig.package.name;
    const dependencies = spagoConfig.package.dependencies;

    for (const dep of dependencies) {
      allDependencies.add(dep);
    }

    localPackageNames.add(packageName);

    fs.mkdirSync(path.join(tgtRepoDir, "src"), {
      recursive: true,
      force: true,
    });

    const srcDir = path.join(dir, "src");
    const tgtDir = path.join(tgtRepoDir, "src", packageName);

    console.error(`Copying ${srcDir} to ${tgtDir}`);
    fs.cpSync(srcDir, tgtDir, { recursive: true });
    console.error(`Done`);
  }

  for (const localPackageName of localPackageNames) {
    allDependencies.delete(localPackageName);
  }

  const wsConfig = readSpagoConfig("spago.yaml");

  const { version, extra } = readVersion();

  const mainCfg = {
    package: {
      dependencies: [...allDependencies],
      name: "interactive-data",
      publish: {
        version,
        license: "BSD-3-Clause",
        location: githubRepo,
      },
    },
    workspace: wsConfig.workspace,
  };

  const tgtSpagoConfig = path.join(tgtRepoDir, "spago.yaml");

  console.error(`Writing ${tgtSpagoConfig}`);
  writeSpagoConfig(tgtSpagoConfig, mainCfg);
  console.error(`Done`);

  fs.writeFileSync(path.join(tgtRepoDir, "README.md"), readmeTemplate, "utf8");
  fs.writeFileSync(
    path.join(tgtRepoDir, ".gitignore"),
    gitignoreTemplate,
    "utf8"
  );

  spagoEnsureRanges(tgtRepoDir);

  cp.execSync(`git add '*'`, { cwd: tgtRepoDir });
  cp.execSync(`git commit -m "v${version}"`, {
    cwd: tgtRepoDir,
  });
  cp.execSync(`git tag v${version}-${extra}`, { cwd: tgtRepoDir });
};

main();

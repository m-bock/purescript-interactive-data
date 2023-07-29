import { globSync } from "glob";
import * as fs from "fs";
import * as cp from "child_process";
import yaml from "js-yaml";
import path from "path";

const git = "ssh://git@github.com/thought2/purescript-interactive-data.git";

const dstFile = "./docs/extra-packages.yaml";

const getCurrentRef = () => {
  const ref = cp.execSync("git rev-parse HEAD");
  return ref.toString().trim();
};

const getEntry =
  ({ ref }) =>
  (file) => {
    const content = fs.readFileSync(file, "utf8");
    const spagoYaml = yaml.load(content);

    const subdir = path.dirname(file);
    const name = spagoYaml.package.name;
    const dependencies = spagoYaml.package.dependencies || [];

    return [name, { git, ref, subdir, dependencies }];
  };

const getLocalEntries =
  ({ ref }) =>
  (files) => {
    const accum = {};
    for (const file of files) {
      const [key, val] = getEntry({ ref })(file);
      accum[key] = val;
    }
    return accum;
  };

const getDepEntries = () => {
  const content = fs.readFileSync("./spago.yaml", "utf8");
  const spagoYaml = yaml.load(content);
  return spagoYaml.workspace.extra_packages || [];
};

const main = () => {
  const spagoYamlFiles = globSync("packages/**/*/spago.yaml");

  const ref = getCurrentRef();

  const localEntries = getLocalEntries({ ref })(spagoYamlFiles);

  const depEntries = getDepEntries();

  const allEntries = { ...localEntries, ...depEntries };

  const final = {
    workspace: {
      extra_packages: allEntries,
    },
  };

  const finalYaml = yaml.dump(final);

  fs.writeFileSync(dstFile, finalYaml, "utf8");
};

main();

import { globSync } from "glob";
import * as fs from "fs";

const parseModule = (modulePath) => {
  const source = fs.readFileSync(modulePath, "utf-8").toString();

  const res = source.match(
    /module\s+(?<moduleName>[A-Za-z.]+)\s*(?<exports>\([\s\S]*?\))?\s*where/m
  );
  const { moduleName, exports } = res.groups;

  const imports = [...source.matchAll(/\nimport\s+([A-Za-z0-9.]+)/g)].map(
    (x) => x[1]
  );

  return {
    moduleName,
    exports,
    imports,
    modulePath,
  };
};

const getGraph = (modulePaths) => {
  const out = {};

  for (const modulePath of modulePaths) {
    const res = parseModule(modulePath);

    out[res.moduleName] = res;
  }

  const out2 = Object.fromEntries(
    Object.values(out).map(({ moduleName, modulePath }) => [
      moduleName,
      {
        modulePath,
        moduleName,
        externalImports: [],
        localImports: [],
        importedBy: [],
      },
    ])
  );

  for (const { moduleName, imports } of Object.values(out)) {
    const localImports = imports.filter((x) => out[x]);
    const externalImports = imports.filter((x) => !out[x]);

    for (const importName of localImports) {
      out2[importName].importedBy.push(moduleName);
    }

    out2[moduleName].externalImports = externalImports;
    out2[moduleName].localImports = localImports;
  }

  return out2;
};

const getModList = (graph) => {
  const out = [];
  const visited = new Set();

  const leaves = Object.values(graph).filter(
    ({ localImports }) => localImports.length === 0
  );

  const visitModule = (mod) => {

    for (const dependancy of mod.localImports) {
      const dep = graph[dependancy];

      visitModule(dep);
    }

    if (visited.has(mod.moduleName)) return;

    out.push(mod);
    visited.add(mod.moduleName);

    for (const dependant of mod.importedBy) {
      const dep = graph[dependant];

      visitModule(dep);
    }
  };

  for (const leaf of leaves) {
    visitModule(leaf);
  }
  return out;
};

const main = () => {
  const modulePaths = [
    ...globSync("packages/*/src/**/*.purs"),
    ...globSync("packages/*/test/**/*.purs"),
    ...globSync("demo/src/**/*.purs"),
    ...globSync("demo/test/**/*.purs"),
  ];

  const graph = getGraph(modulePaths);

  const mods = getModList(graph);

    // for (let i = 0; i < mods.length; i++) {
    //   const mod = mods[i];
    //   console.log(`${i + 1}. ${mod.modulePath}`);
    //   for (const dep of mod.importedBy) {
    //     console.log(`      - ${graph[dep].modulePath}`);
    //   }
    //   console.log(``);
    // }

  for (let mod of mods) {
    console.log(mod.modulePath);
  }

  // console.log(mods.length)
};

main();

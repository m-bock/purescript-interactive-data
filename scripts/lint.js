import { globSync } from "glob";
import * as fs from "fs";

const main = () => {
  const modulePaths = [
    ...globSync("packages/*/src/**/*.purs"),
    ...globSync("packages/*/test/**/*.purs"),
    ...globSync("demo/src/**/*.purs"),
    ...globSync("demo/test/**/*.purs"),
  ];

  let problems = 0;

  for (const modulePath of modulePaths) {
    const source = fs.readFileSync(modulePath, "utf-8").toString();

    const res = source.match(
      /module\s+(?<moduleName>[A-Za-z.]+)\s*(?<exports>\([\s\S]*?\))?\s*where/m
    );
    const { moduleName, exports } = res.groups;

    const imports = [...source.matchAll(/\nimport\s+([A-Za-z0-9.]+)/g)].map(
      (x) => x[1]
    );

    console.log(modulePath);
    console.log(imports);
    console.log("\n");

    const moduleNameByPath = modulePath
      .split("src/")[1]
      .replace(".purs", "")
      .split("/")
      .join(".");

    if (moduleName !== moduleNameByPath) {
      console.error(`${modulePath} : Module name mismatch`);
      console.error(`  Expected: ${moduleNameByPath}`);
      console.error(`  Actual:   ${moduleName}`);
      console.error(``);
      problems += 1;
    }

    if (
      modulePath !==
      "packages/interactive-data-app/src/InteractiveData/App/UI/Assets.purs"
    ) {
      if (typeof exports === "undefined") {
        console.error(`${modulePath} : open exports`);
        console.error(``);
        problems += 1;
      }
    }
  }

  if (problems > 0) {
    console.error(`Found ${problems} problems`);
    process.exit(1);
  }
};

main();

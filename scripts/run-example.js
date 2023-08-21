import select from "@inquirer/select";
import * as fs from "fs";

const out = process.argv[2];

const sampleValues = fs.readdirSync("demo/static");

const samplesChoices = sampleValues.map((name) => {
  return {
    name,
    value: name,
  };
});

const main = async () => {
  const sample = await select({
    message: "Select an Example",
    choices: samplesChoices,
  });

  fs.writeFileSync(out, sample.trim());
};

main();

import select from "@inquirer/select";
import * as fs from "fs";

const out = process.argv[2];

const sampleValues = fs.readdirSync("demo/src/Demo/Samples");

const choices = sampleValues.map((name) => {
  return {
    name,
    value: name,
  };
});

const getAnswer = () =>
  select({
    message: "Select an Example",
    choices,
  });

const main = async () => {
  const answer = await getAnswer();
  fs.writeFileSync(out, answer.trim());
};

main();

import * as fs from "fs";
import * as cp from "child_process";

const getStdin = async () => {
  const data = await fs.readFileSync(0, "utf-8");
  return data;
};

const filterWarning = ({ errorCode, filename, message, moduleName }, index) => {
  if (filename.startsWith(".spago")) return false;
  return true;
};

const main = async () => {
  const stdin = await getStdin();
  const problems = JSON.parse(stdin);


  console.log(problems)

  const warnings = problems.warnings;

  const warningsFiltered = warnings.filter(filterWarning);

  const problemsFiltered = {
    ...problems,
    warnings: warningsFiltered,
  };

  console.log(JSON.stringify(problemsFiltered));

  console.error(`Errors: ${problemsFiltered.errors.length}`);
  console.error(`Warnings: ${problemsFiltered.warnings.length}`);

  if (problemsFiltered.errors.length > 0) {
    process.exit(1);
  }

  if (problemsFiltered.warnings.length > 0) {
    process.exit(1);
  }
};

main();

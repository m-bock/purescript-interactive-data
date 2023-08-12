import * as fs from "fs";

const getStdin = async () => {
  const data = await fs.readFileSync(0, "utf-8");
  return data;
};

const filterWarning = ({ errorCode, filename, message, moduleName }, index) => {
  if (filename.startsWith(".spago")) return false;
  if (errorCode === "WildcardInferredType") return false;
  return true;
};

const main = async () => {
  const stdin = await getStdin();
  const problems = JSON.parse(stdin);

  const warnings = problems.warnings;

  const warningsFiltered = warnings.filter(filterWarning);

  const problemsFiltered = {
    errors: problems.errors,
    warnings: warningsFiltered,
  };

  console.log(JSON.stringify(problemsFiltered));

  console.error(``)

  for (const warning of problemsFiltered.warnings) {
    console.error(`WARN  ${warning.filename}:${warning.position.startLine}:${warning.position.startColumn}`);
  }

  for (const error of problemsFiltered.errors) {
    console.error(`ERROR ${error.filename}:${error.position.startLine}:${error.position.startColumn}`);
  }

  console.error(``)

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

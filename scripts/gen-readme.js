import { idPatchMd } from "./id-patch-md.js";
import * as fs from "fs";

const main = () => {
  const source = fs.readFileSync("./README.md", "utf8").toString();

  const result = idPatchMd(source);

  fs.writeFileSync("./README.md", result, "utf8");
};

main();

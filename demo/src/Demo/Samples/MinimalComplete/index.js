import { main } from "../../../../../output/Demo.Samples.MinimalComplete.Main/index.js";

const envVars = {};

if (typeof process.env.SAMPLE !== "undefined") {
  envVars.SAMPLE = process.env.SAMPLE;
}

main(envVars)();

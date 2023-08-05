import { main } from "../../../../../output/Demo.Samples.MinimalComplete/index.js";

const envVars = {};

if (typeof process.env.SAMPLE !== "undefined") {
  envVars.SAMPLE = process.env.SAMPLE;
}

main(envVars)();

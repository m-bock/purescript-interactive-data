import { main } from "../../output/Demo.Main/index.js";

const envVars = {};

if (typeof process.env.SAMPLE !== "undefined") {
  envVars.SAMPLE = process.env.SAMPLE;
}

if (typeof process.env.FRAMEWORK !== "undefined") {
  envVars.FRAMEWORK = process.env.FRAMEWORK;
}

main(envVars)();

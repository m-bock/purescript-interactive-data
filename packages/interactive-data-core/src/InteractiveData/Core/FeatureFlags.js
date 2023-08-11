export const envVars = (() => {
  // check if process exists:
  if (typeof process === "undefined") return {};
  if (typeof process.env === "undefined") return {};

  const envVars = {};

  // Filter out undefined values:
  for (const key in envVars) {
    if (typeof envVars[key] === "undefined") {
      delete envVars[key];
    }
  }

  if (Object.keys(envVars).length !== 0) {
    console.log("envVars", envVars);
  }

  return envVars;
})();

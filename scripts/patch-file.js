// @ts-check

/**
 * @typedef {[RegExp, (match : string, groups: string[], index: number, all :string ) => string]} RegexPatch_
 * @typedef {[RegExp, (match : string, ...args: any[] ) => string | Promise<string> ]} RegexPatch
 */

export const langs = {
  md: { open: "<!--", close: "-->" },
  purs: { open: "{-", close: "-}" },
};

/**
 * @param {{open: string, close: string}} lang
 * */
const mkReplace =
  ({ open, close }) =>
  /**
   * @param {string} name
   * @param {string} arg
   */
  (name, arg) =>
  /**
   * @param {string} patch
   */
  (patch) => {
    const arg_ = arg === "" ? "" : ` ${arg}`;
    return `${open} START ${name}${arg_} ${close}${patch}${open} END ${name} ${close}`;
  };

/**
 * @param {{open: string, close: string}} lang
 * */
const mkRegex = ({ open, close }) => {
  return new RegExp(
    `${open} START ([a-zA-Z0-9_]+)(.*?)${close}([\\s\\S]*?)${open} END ([a-zA-Z0-9_]+) ${close}`,
    "g"
  );
};

/**
 * @param {object} lang
 * @param {string} lang.open
 * @param {string} lang.close
 * */
export const patchAll =
  (lang) =>
  /**
   * @param {Object.<string, string | ((_1: string, _2: string, _3: number, _4: string) => string) | RegexPatch>} patchData
   * */
  (patchData) =>
  /**
   * @param {string} source
   * */
  async (source) => {
    const regex = mkRegex(lang);

    let newSource = source;

    newSource = source.replace(
      regex,
      (match, nameOpen, arg_, content, nameClose, index, all) => {
        if (nameOpen !== nameClose) {
          throw new Error(
            `Mismatched open/close name: '${nameOpen}' is not '${nameClose}'`
          );
        }
        const name = nameOpen;

        const patch = patchData[name];

        if (typeof patch === "undefined") {
          throw new Error(`No patch for '${name}'`);
        }

        const arg = arg_.trim();

        const newContent =
          typeof patch === "function"
            ? patch(content, arg, index, all)
            : typeof patch === "string"
            ? patch
            : content;

        return mkReplace(lang)(name, arg)(newContent);
      }
    );

    const regexPatches = /** @type RegexPatch[] */ (
      Object.values(patchData).filter((val) => Array.isArray(val))
    );

    for (const [regex, patch] of regexPatches) {
      newSource = await replaceAsync(newSource, regex, async (...args) => {
        const newContent =
          typeof patch === "function"
            ? patch(...args)
            : typeof patch === "string"
            ? patch
            : (() => {
                throw new Error("unsupported patch");
              })();

        return newContent;
      });
    }

    return newSource;
  };

/**
 *
 * @param {string} str
 * @param {RegExp} regex
 * @param {(match: string, ...args: any) => Promise<string>} asyncFn
 * @returns {Promise<string>}
 */
const replaceAsync = async (str, regex, asyncFn) => {
  /**
   * @type {Promise<string>[]}
   */
  const promises = [];

  str.replace(regex, (match, ...args) => {
    const promise = asyncFn(match, ...args);
    promises.push(promise);
    return match;
  });
  const data = await Promise.all(promises);
  return str.replace(regex, () => data.shift() || "");
};

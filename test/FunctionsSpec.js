import fs from "fs";

const loadFile = (file) => fs.readFileSync(file, "utf8");

export const elmCore = loadFile("data/elm/core.txt");
export const haskellPrelude = loadFile("data/haskell/prelude.txt");
export const purescriptPrelude = loadFile("data/purescript/prelude.txt");

import fs from "fs";

const loadFile = (file) => fs.readFileSync(file, "utf8");

export const elmCore = loadFile("data/elm/core.txt");
export const haskellFunctions = loadFile("data/haskell/functions.txt");
export const haskellLens = loadFile("data/haskell/lens.txt");
export const purescriptFunctions = loadFile("data/purescript/functions.txt");

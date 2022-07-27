import fs from "fs";

const loadFile = (file) => fs.readFileSync(file, "utf8");

export const haskellFunctionsText = loadFile("data/haskell/functions.txt");

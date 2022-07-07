import { main } from "../output/Main/index";
import file from "url:../data/prelude.txt";

if (module.hot) {
  module.hot.accept(function () {
    console.log("Reloaded, running main again");
    main();
  });
}

console.log(file);

main();

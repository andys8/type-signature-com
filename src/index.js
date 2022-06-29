import * as Main from "../output/Main/index";

if (module.hot) {
  module.hot.accept(function () {
    console.log("Reloaded, running main again");
    Main.main();
  });
}

Main.main();

/** @type {import('tailwindcss').Config} */

module.exports = {
  content: ["./src/**/*.{html,js,purs}", "node_modules/daisyui/dist/**/*.js"],
  theme: {
    extend: {},
    fontFamily: {
      mono: ["Fira Code", "monospace"],
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["dracula"],
  },
};

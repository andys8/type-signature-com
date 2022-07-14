/** @type {import('tailwindcss').Config} */

module.exports = {
  content: ["./src/**/*.{html,js,ts,jsx,tsx,purs}"],
  theme: {
    extend: {},
    fontFamily: {
      mono: ["Fira Code", "monospace"],
    },
  },
  safelist: [{ pattern: /./ }],
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["dracula"],
  },
};

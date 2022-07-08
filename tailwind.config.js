/** @type {import('tailwindcss').Config} */

// TODO: Reduce tailwind css bundle size
module.exports = {
  content: ["./src/**/*.{html,js,ts,jsx,tsx,purs}"],
  theme: { extend: {} },
  safelist: [{ pattern: /./ }],
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["dracula"],
  },
};

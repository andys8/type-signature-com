/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,js,ts,jsx,tsx,purs}"],
  theme: { extend: {} },
  safelist: [{ pattern: /./ }],
  plugins: [require("daisyui")]
};

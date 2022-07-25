/** @type {import('tailwindcss').Config} */

module.exports = {
  content: ["./src/**/*.{html,js,purs}", "node_modules/daisyui/dist/**/*.js"],
  theme: {
    extend: {
      animation: {
        wiggle: "wiggle 0.3s ease-in-out 1",
      },
      keyframes: {
        wiggle: {
          "0%, 100%": {
            transform: "translateX(0)",
          },
          "30%, 70%": {
            transform: "translateX(-3%)",
          },
          "10%, 50%, 90%": {
            transform: "translateX(3%)",
          },
        },
      },
      backgroundImage: {
        "logo-alt": "url('/public/logo-alt-bg.png')",
      },
    },
    fontFamily: {
      mono: ["Fira Code", "monospace"],
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: ["dracula"],
  },
};

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,jsx}"],
  theme: {
    extend: {
      colors: {
        primary: {
          50: "#f5f2ff",
          100: "#e6e0ff",
          200: "#cbbfff",
          300: "#a98cff",
          400: "#8657ff",
          500: "#5f2eff",
          600: "#4a1fd1",
          700: "#3716a3",
          800: "#240057",
          900: "#1a003d",
        },
      },
    },
  },
  plugins: [],
};
const colors = require('tailwindcss/colors')

module.exports = {
  mode: 'jit',
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {},
  variants: {
    extend: {}
  },
  plugins: []
}

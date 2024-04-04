// See the Tailwind default theme values here:
// https://github.com/tailwindcss/tailwindcss/blob/master/stubs/defaultConfig.stub.js
const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
    content: [
        './app/views/**/*.html.erb',
        './app/helpers/**/*.rb',
        './app/assets/stylesheets/**/*.css',
        './app/javascript/**/*.js',
        './node_modules/flowbite/**/*.js'
    ],
    plugins: [
        require('flowbite/plugin')
    ],
    theme: {
        // Extend (add to) the default theme in the `extend` key
        extend: {
            // Create your own at: https://javisperez.github.io/tailwindcolorshades
            colors: {
                primary: colors.red,
                secondary: colors.emerald,
                tertiary: colors.blue,
                success: colors.green,
                danger: colors.rose,
                gray: colors.neutral
            },
            fontFamily: {
                sans: ['Inter', ...defaultTheme.fontFamily.sans],
            },
        },

        // Opt-in to TailwindCSS future changes
        future: {},
    },
}

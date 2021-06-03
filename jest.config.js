module.exports = {
  preset: '@vue/cli-plugin-unit-jest/presets/no-babel',
  transform: {
    'vee-validate/dist/rules': 'babel-jest',
  },
  transformIgnorePatterns: [
    '<rootDir>/node_modules/(?!vee-validate/dist/rules)',
  ],
}

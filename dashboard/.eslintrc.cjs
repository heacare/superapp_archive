module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    jest: true,
  },
  parser: 'vue-eslint-parser',
  parserOptions: {
    parser: '@typescript-eslint/parser',
    // @typescript-eslint/parser
    tsconfigRootDir: __dirname,
    project: ['./tsconfig.json'],
    extraFileExtensions: ['vue'],
  },
  plugins: ['@typescript-eslint/eslint-plugin'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:vue/vue3-recommended',
    'plugin:prettier/recommended',
  ],
  rules: {
    //'@typescript-eslint/interface-name-prefix': 'off',
    //'@typescript-eslint/explicit-function-return-type': 'off',
    //'@typescript-eslint/explicit-module-boundary-types': 'off',
    //'@typescript-eslint/no-explicit-any': 'off',
    'vue/multi-word-component-names': 'off',
  },
};

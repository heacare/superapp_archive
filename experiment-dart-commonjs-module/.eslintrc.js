module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    jest: true,
  },
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: ['./tsconfig.json'],
  },
  plugins: ['@typescript-eslint/eslint-plugin'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:prettier/recommended',
  ],
  rules: {
    //'@typescript-eslint/interface-name-prefix': 'off',
    //'@typescript-eslint/explicit-function-return-type': 'off',
    //'@typescript-eslint/explicit-module-boundary-types': 'off',
    //'@typescript-eslint/no-explicit-any': 'off',
  },
};

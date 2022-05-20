import { execute } from '..';

/* eslint-disable @typescript-eslint/no-unsafe-call */

test('execute basic', () => {
  expect(execute('hello')).toBe('hellohello');
});

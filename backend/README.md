## Installation

```bash
$ npm install
```

## Running the app

Hot reload with VSCode debugging based on [this](https://blog.logrocket.com/containerized-development-nestjs-docker/) (connects to Postgres):

```bash
# development
$ docker-compose -f .\docker-compose.dev.yml up --build
```

Server at port `3000`.

Adminer (db manager) at port `5433`.

## Test
.. are non-existent

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```
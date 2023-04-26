# Custom AWS lambda Docker image with hot reloading development enviroment

This project is an example and a starting point for creating a custom AWS lambda docker image with hot reloading development enviroment. The project uses [aws-lambda-rie](https://github.com/aws/aws-lambda-runtime-interface-emulator) and [aws-lambda-ric](https://github.com/aws/aws-lambda-nodejs-runtime-interface-client)

## Running

To make running this project easier there is a included docker-compose.yml file. To get started just run:

```bash
docker compose  -f "docker-compose.yml" up -d --build development
```

The dockerfile will install all the dependencies and run the custom package.json script that starts nodemon that watches for changes in `./function` folder and restarts the rie and ric processes if needed.

**IF YOU ADD NPM PACKAGES YOU NEED TO REBUILD THE DOCKER IMAGE**

The compose file will mount the `./function` folder to the container and expose the port 9000 for the rie to listen on. This enables you to make changes to the code and see the changes immediately. The api aws-lambda-rie uses is:

```bash
http://localhost:9000/2015-03-31/functions/function/invocations
```

You can test the api with curl:

```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"body": "test"}'
```

## Testing

You can run the tests with the `Development.Dockerfile` using docker-compose with:

```bash
docker compose  -f "docker-compose.yml" up -d --build tests
```

Or without compose:

```bash
docker build -f Development.Dockerfile -t aws-custom-image .
docker run -it --rm --name aws-custom-image aws-custom-image ./entrypoint.test.sh
```

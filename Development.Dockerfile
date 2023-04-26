FROM node:18-bullseye
WORKDIR /usr/app

# Install aws-lambda-ric cpp dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev \
    lsof


# Install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
RUN yarn add aws-lambda-ric

# Copy the source code
# We will mount the source code as a volume in the docker-compose file for reloads on changes
COPY function ./function
COPY tests ./tests
COPY tsconfig.json ./
COPY nodemon.json ./
COPY .mocharc.json ./

# Copy the entrypoint scripts
COPY entrypoint.dev.sh ./
RUN chmod +x ./entrypoint.dev.sh

COPY entrypoint.test.sh ./
RUN chmod +x ./entrypoint.test.sh

# Copy the aws-lambda-runtime-interface-emulator
COPY aws-lambda-rie ./aws-lambda-rie

CMD ["yarn", "dev"]
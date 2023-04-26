FROM node:18-bullseye as build-image

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
COPY function ./function
COPY tsconfig.json ./

# Build the minified and bundled code to /dist
RUN yarn build

# Create the final image
FROM node:18-bullseye-slim

WORKDIR /usr/app

# Copy the built code from the build image
COPY --from=build-image /usr/app/dist ./dist
COPY --from=build-image /usr/app/package.json ./package.json

RUN apt-get update

# Librsvg2 (rsvg-convert)
RUN apt-get install -y librsvg2-bin

# Inkscape 1.0.2
RUN apt-get install -y inkscape

# pstoedit
RUN apt-get install -y pstoedit

# Install the aws-lambda-ric
COPY --from=build-image /usr/app/node_modules/aws-lambda-ric ./node_modules/aws-lambda-ric

# Run the aws-lambda-ric
ENTRYPOINT [ "node", "node_modules/aws-lambda-ric/bin/index.js" ]
CMD [ "dist/index.handler" ]
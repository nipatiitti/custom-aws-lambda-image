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


# Install any dependencies you might need e.g.
# RUN apt-get update && apt-get install -y \
#   inkscape \
#   imagemagick


# Install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
RUN yarn add aws-lambda-ric

# Copy the rest
COPY . .

COPY entrypoint.dev.sh ./
RUN chmod +x ./entrypoint.dev.sh

COPY entrypoint.test.sh ./
RUN chmod +x ./entrypoint.test.sh

# Copy the aws-lambda-runtime-interface-emulator
COPY aws-lambda-rie ./aws-lambda-rie
RUN chmod +x ./aws-lambda-rie

CMD ["yarn", "dev"]
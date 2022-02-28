FROM docker.io/library/node:bullseye-slim AS base

# Define the current directory based on defacto community standard
WORKDIR /usr/src/app

FROM base AS runtime

# Pull production only depedencies
COPY package.json yarn.lock ./
RUN yarn install --production

FROM runtime AS builder

# Pull all depedencies
RUN --mount=id=yarn-cache,type=cache,sharing=locked,target=/root/.cache/yarn \
  yarn install

FROM builder AS source

# Copy source
COPY . .

FROM source AS build

# Build application
ENV NODE_ENV=production
RUN --mount=id=yarn-cache,type=cache,sharing=locked,target=/root/.cache/yarn \
  yarn build

FROM runtime

# Switch to the node default non-root user
USER node

# Copy build
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/src ./src

# Set entrypoint
EXPOSE 3000
CMD [ "yarn", "start" ]

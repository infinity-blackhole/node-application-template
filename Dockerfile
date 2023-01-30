FROM node:bullseye-slim AS base

# Define the current directory based on defacto community standard
WORKDIR /usr/src/app

FROM base AS runtime

# Pull production only depedencies
COPY package.json package-lock.json ./
RUN --mount=type=cache,sharing=locked,target=/root/.npm \
  npm ci --production

FROM runtime AS builder

# Pull all depedencies
RUN --mount=type=cache,sharing=locked,target=/root/.npm \
  npm ci

FROM builder AS release

# Copy source
COPY . .

# Build application
ENV NODE_ENV=production
RUN --mount=type=cache,sharing=locked,target=/root/.npm \
  npm run build

FROM runtime

# Switch to the node default non-root user
USER node

# Copy build
COPY --from=release /usr/src/app/dist ./dist

# Run application
CMD [ "npm", "run", "start" ]

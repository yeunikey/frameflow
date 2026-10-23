FROM node:24.15.0-bookworm-slim@sha256:4e6b70dd6cbfc88c8157ba19aa3d9f9cce6ba4703576d55459e45efcbc9c5f5d AS base
ENV PNPM_HOME=/pnpm
ENV PATH=$PNPM_HOME:$PATH
RUN corepack enable && corepack prepare pnpm@10.34.5 --activate
WORKDIR /workspace

FROM base AS dependencies
ARG SERVICE_NAME
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./
COPY services/${SERVICE_NAME}/package.json ./services/${SERVICE_NAME}/package.json
RUN pnpm install --frozen-lockfile --filter @frameflow/${SERVICE_NAME}

FROM dependencies AS development
ARG SERVICE_NAME
COPY services/${SERVICE_NAME} ./services/${SERVICE_NAME}
RUN chown -R node:node /workspace
WORKDIR /workspace/services/${SERVICE_NAME}
USER node
CMD ["pnpm", "start:dev"]

FROM dependencies AS build
ARG SERVICE_NAME
COPY services/${SERVICE_NAME} ./services/${SERVICE_NAME}
RUN pnpm --filter @frameflow/${SERVICE_NAME} build

FROM base AS production-dependencies
ARG SERVICE_NAME
ENV NODE_ENV=production
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./
COPY services/${SERVICE_NAME}/package.json ./services/${SERVICE_NAME}/package.json
RUN pnpm install --prod --frozen-lockfile --filter @frameflow/${SERVICE_NAME}

FROM node:24.15.0-bookworm-slim@sha256:4e6b70dd6cbfc88c8157ba19aa3d9f9cce6ba4703576d55459e45efcbc9c5f5d AS runtime
ARG SERVICE_NAME
ENV NODE_ENV=production HTTP_HOST=0.0.0.0
WORKDIR /app
COPY --from=production-dependencies --chown=node:node /workspace/node_modules ./node_modules
COPY --from=production-dependencies --chown=node:node /workspace/services/${SERVICE_NAME}/package.json ./services/${SERVICE_NAME}/package.json
COPY --from=production-dependencies --chown=node:node /workspace/services/${SERVICE_NAME}/node_modules ./services/${SERVICE_NAME}/node_modules
COPY --from=build --chown=node:node /workspace/services/${SERVICE_NAME}/dist ./services/${SERVICE_NAME}/dist
WORKDIR /app/services/${SERVICE_NAME}
USER node
CMD ["node", "dist/main.js"]

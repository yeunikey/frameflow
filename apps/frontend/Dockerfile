FROM node:24.15.0-bookworm-slim@sha256:4e6b70dd6cbfc88c8157ba19aa3d9f9cce6ba4703576d55459e45efcbc9c5f5d AS base
ENV PNPM_HOME=/pnpm
ENV PATH=$PNPM_HOME:$PATH
ENV NEXT_TELEMETRY_DISABLED=1
RUN corepack enable && corepack prepare pnpm@10.34.5 --activate
WORKDIR /workspace

FROM base AS dependencies
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./
COPY apps/frontend/package.json ./apps/frontend/package.json
RUN pnpm install --frozen-lockfile --filter @frameflow/frontend

FROM dependencies AS build
COPY apps/frontend ./apps/frontend
ARG NEXT_PUBLIC_API_BASE_URL=/v1
ENV NEXT_PUBLIC_API_BASE_URL=$NEXT_PUBLIC_API_BASE_URL
RUN pnpm --filter @frameflow/frontend build

FROM node:24.15.0-bookworm-slim@sha256:4e6b70dd6cbfc88c8157ba19aa3d9f9cce6ba4703576d55459e45efcbc9c5f5d AS runtime
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 PORT=3000 HOSTNAME=0.0.0.0
WORKDIR /app
COPY --from=build --chown=node:node /workspace/apps/frontend/.next/standalone ./
COPY --from=build --chown=node:node /workspace/apps/frontend/.next/static ./apps/frontend/.next/static
COPY --from=build --chown=node:node /workspace/apps/frontend/public ./apps/frontend/public
USER node
EXPOSE 3000
CMD ["node", "apps/frontend/server.js"]

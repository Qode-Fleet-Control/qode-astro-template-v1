# Built by .github/workflows/deploy.yml (context ., file Dockerfile) and pushed
# to Artifact Registry. Adapted from the fleet's static stack pack.
#
# Deviations from the pack, and why:
#   - `npm install` when no lockfile is committed; the pack assumes `npm ci`,
#     which fails outright without one.
#   - node:22, not the pack's node:20: Astro requires >=22.12 and Nuxt's build
#     crashes on 20 (trustedFunctions.difference is not a function).

FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi
COPY . .
RUN npm run build

FROM nginxinc/nginx-unprivileged:1.27-alpine AS runtime
ARG BUILD_ID=""
ENV PORT=8080 BUILD_ID=$BUILD_ID
COPY --from=build /app/dist /usr/share/nginx/html
# nginx server config (incl. the per-request JSON access log): nginx/default.conf.template.
# The image's entrypoint renders /etc/nginx/templates/*.template into conf.d at start.
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
EXPOSE 8080

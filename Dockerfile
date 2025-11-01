FROM node:22.21.1-alpine3.21@sha256:af8023ec879993821f6d5b21382ed915622a1b0f1cc03dbeb6804afaf01f8885 AS base

WORKDIR /app

FROM base AS build

# Copy package.json and package-lock.json to the working directory.
COPY package.json package-lock.json ./

# Install dependencies using npm ci for a clean, reproducible build.
# This command also sets the NODE_ENV to production to avoid installing devDependencies.
RUN npm ci --omit=dev

# --- Production Stage ---
# This stage is responsible for running the application.
FROM base AS production

# Copy the installed dependencies from the build stage.
COPY --from=build /app/node_modules ./node_modules

# Copy the rest of the application code to the working directory.
COPY . .

# Expose port 9000 to allow outside access.
EXPOSE 9000

# Set the command to run the application.
CMD ["node", "express.js"]

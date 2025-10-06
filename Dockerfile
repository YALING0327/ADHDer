# Use Node.js 18
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/web/package.json ./apps/web/
COPY packages/db/package.json ./packages/db/
COPY packages/sdk/package.json ./packages/sdk/

# Install pnpm
RUN npm install -g pnpm

# Install dependencies
RUN pnpm install

# Copy source code
COPY . .

# Generate Prisma client
RUN cd apps/web && npx prisma generate

# Build the application
RUN cd apps/web && npm run build

# Expose port
EXPOSE 3000

# Start the application
WORKDIR /app/apps/web
CMD ["npm", "start"]

/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: { appDir: true },
  transpilePackages: ["@adhder/db", "@adhder/sdk"],
};

export default nextConfig;



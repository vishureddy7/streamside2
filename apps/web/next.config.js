const path = require('node:path')

// Load environment variables from the monorepo root .env
// This is needed because Next.js only auto-loads .env from its project directory
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') })

/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    output: 'standalone',
    experimental: {
        serverActions: {
            bodySizeLimit: '100mb', // For large video chunks
        },
    },
}

module.exports = nextConfig
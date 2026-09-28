// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
// The fleet serves this app at its own hostname and passes it in as FLEET_APP_HOST.
// `astro dev` and `astro preview` answer any other Host with "Blocked request. This
// host is not allowed", so trust exactly that one; with no fleet hostname (another
// host, a cluster ingress) there is no way to know it up front, so accept any.
const allowedHosts = process.env.FLEET_APP_HOST ? [process.env.FLEET_APP_HOST] : true;

export default defineConfig({
  server: { allowedHosts },
});

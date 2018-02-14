# nginx-proxy-pwa

nginx-proxy-pwa adds some common rules to nginx-proxy:alpine support PWAs with http/2 push manifest.
An example issue this image attempts to alleviate is the instance of the error `upstream sent too big header while reading response header from upstream` during reverse proxy of http/2 requests.

This image extends [jwilder/nginx-proxy:alpine](https://github.com/jwilder/nginx-proxy), and users should refer that repository's documentation for additional info regarding nginx-proxy.

## Usage

The following example assumes an http server (i.e. nodeJS-express) open to port 3001, with SSL at the proxy.

Generating certs (required for http/2 and service-worker):
`mkdir certs`
`cd certs`
`openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./localhost.key -out ./localhost.crt`

Docker-compose file with volumes
```dockerfile
version: '3'
services:
  web:
    build: .
    ports:
      - 3001:3001
    environment:
      - VIRTUAL_PORT=3001
      - VIRTUAL_HOST=localhost
      - NODE_ENV=production
    networks:
      - web

  nginx-proxy-pwa:
    image: krumware/nginx-proxy-pwa
    ports:
      - "8443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./certs:/etc/nginx/certs
    networks:
      - web

# Optional, from original nginx-proxy sample
  whoami:
    image: jwilder/whoami
    environment:
      - VIRTUAL_HOST=whoami.local
    networks:
      - web

networks:
  web:
    driver: overlay
```

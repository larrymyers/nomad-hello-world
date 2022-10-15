# Nomad "Hello World!"

This is the companion sample project for running your own deployment infrastructure with Traefik and Nomad.

Blog Post: https://www.larrymyers.com/posts/nomad-and-traefik/

You can see it running at: https://hello.larrymyers.com/

This project demonstrates the following:

- Using the git commit short hash as a version.
- Using docker multi-stage builds to create slim images.
- Using Nomad environment variables at runtime to bind the server to the correct hostname.
- Using Nomad secure variables to provide secrets via environment variable.
- Using tags to auto-configure routing with Traefik.

## Setup

- Go 1.16+
- Nomad 1.4+

Replace any instances of "your-domain.tld" with the actual domain you want to use with your hosting setup.

## Development

    MESSAGE=<your message here> go run main.go
    http://localhost:8000

## Build and Deploy

    NOMAD_ADDR=http://nomad.your-domain.tld NOMAD_TOKEN=<your Nomad ACL token> ./deploy.sh

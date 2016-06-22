# dev

Development Environment!

## Quick start

```bash
git clone --recursive git@github.com:tritonjs/dev # You're going to need SSH setup anyways.

# OR

git clone https://github.com/tritonjs/dev
cd dev
git submodule init
git submodule pull

# THEN!
# Make sure to setup the configs!
docker-compose up
```

## Configuration

Here's a list of configs to be modified according to their respective repos.

* `./backend/config/config.json`
* `./ui/public/config.js`

## Production

Don't use this! Well, yet at least.

# dev

Welcome! This is the base of TRITON. It's what's used to develop it locally, and
serves as the base point for all coding.

## Version

**0.5.2**

### Changelog

* Added Developer Tools
* Fixed `cors` breaking on unknown domains accessing it
* Fixed `auth.js` using old pre-arangodb syntax.

## Quick start

```bash
git clone --recursive git@github.com:tritonjs/dev # You're going to need SSH setup anyways.

# OR

git clone https://github.com/tritonjs/dev

# Setup the submodules.
git submodule init
git submodule update

# FOR BOTH

# If you want to use the latest code, instead of the "snapshot"
git pull --recurse-submodules

# Start coding! Check the docker-compose file for the ports.
docker-compose up
```

## Configuration

Here's a list of configs to be modified according to their respective repos.

* `./config/config.example.json -> ./config/config.json`
* `./ui/html/config.js`

# License

MIT

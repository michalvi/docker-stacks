# Docker URsim

## Note

All rights of the offline simulator applications belong to [Universal Robots A/S](https://www.universal-robots.com).

## Usage

### Choose version

```
export VERSION="3.10.1.76190"
```

### Build the image

```
DOCKER_IMAGE=ursim:$VERSION ./build.sh --build-arg VERSION=$VERSION
```

### Run the simulator

Run the simulator in the built container.

```
DOCKER_IMAGE=ursim:$VERSION ./run.sh UR10
```

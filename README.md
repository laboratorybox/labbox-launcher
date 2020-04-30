# labbox-launcher

Launch a labbox container. This Python package has minimal dependencies.

## Installation and example usage

**Prerequisites:**

* Linux
* Docker
* Python 3

**Installation:**

```
pip install --upgrade git+git://github.com/laboratorybox/labbox-launcher
```

**Example usage:**

```bash
# Launch the labbox-ephys container and listen on port 15310 (or whatever you choose)
labbox-launcher run magland/labbox-ephys:0.1.2 --port 15310

# Now, point browser to: http://localhost:15310
```

## What is it doing?

This is a wrapper around `docker run` that does the following:

* Builds a new image based on the provided image.
* Injects a non-root user named labbox into the new image with the same uid/gid as the current user on the host. The labbox user will have sudo privileges inside the container and will be a member of the docker group.
* Mounts the `$KACHERY_STORAGE_DIR` at run time and sets the KACHERY_STORAGE_DIR environment inside the container.


# ROS 1 Docker Setup for ECE 5532

## Installing Prerequisites

First, install Docker CE by following steps 1 through 3 from "Install using the `apt` repository" on this page: [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

In addition to Docker CD, in order to run the graphical ROS tools, the NVIDIA Container Toolkit is required.
The complete installation instructions can be found here: [https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

The relevant instructions are included in this README for your convenience:

1. Configure the production repository:
```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

2. Update `apt` and install the Toolkit packages:

```
sudo apt update && sudo apt install -y nvidia-container-toolkit
```

3. Configure the container runtime by using the `nvidia-ctk` command:

```
sudo nvidia-ctk runtime configure --runtime=docker
```

4. Restart the Docker daemon:

```
sudo systemctl restart docker
```

## Running and Attaching to the Image

The `run.sh` and `new_shell.sh` scripts in this repository automatically set things up for you.

`run.sh` runs the custom container with the appropriate settings, automatically pulling it from DockerHub if it is not found locally.
You should only have to execute this script once to set up the image.

```
./run.sh
```

`new_shell.sh` attaches a bash shell instance to the running container to run commands from.
If the container is not running when this script is run, it will automatically start it.

```
./new_shell.sh
```

## Developing Code in the Container

`run.sh` mounts the `ros` workspace folder in this repository to the `/home/workspace` path in the image.
Simply put your source code in this workspace folder and the container will be able to access it for building.
Using VS Code's Dev Container extension, the active VS Code window and terminals can be loaded in the container.
[![Docker Build](https://github.com/ai-dock/comfyui/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ai-dock/comfyui/actions/workflows/docker-build.yml)

# AI-Dock + ComfyUI Docker Image

This project enables you to run [ComfyUI](https://github.com/comfyanonymous/ComfyUI) within a highly-configurable, cloud-first AI-Dock container with several powerful enhancements tailored for more efficient usage.

## New Features and Enhancements

### 1. Build Support for Custom Comfy3D Pack
Customized to build the **Comfy3D Pack** for generating 3D models from Stable Diffusion outputs.

### 2. Snapshots for Custom Node Versions
Control versions of custom nodes via a JSON file in the **snapshot format**.

### 3. Install Custom Nodes from Local Directory
Install custom nodes from a **local directory** to simplify dependency management.

### 4. Install Prebuilt Wheels
Install prebuilt wheels to optimize build times and enhance dependency resolution.

### 5. Use Local Models via Volume Definitions
Utilize models stored locally by defining volume mappings in the `docker-compose.yaml` file.

## Configuration Steps

### 1. Folder Mappings for Local Deployments

Define folder mappings in `config/provisioning/default.sh`:

```bash
declare -A storage_map
storage_map["stable_diffusion/models/ckpt"]="/opt/ComfyUI/models/checkpoints"
# Add other mappings as needed
```

Ensure volume mappings are included in the docker-compose.yml:

```yaml
volumes:
  - ${MODEL_BASE_PATH}/Stable-diffusion:/opt/storage/stable_diffusion/models/ckpt:ro
  # Add other mappings as needed
```

Set `MODEL_BASE_PATH` in `.env`

```env
MODEL_BASE_PATH=/path/to/your/models/
```

Got it! Here’s the revised and concise configuration documentation, focusing on the correct methods to install custom nodes, prebuilt wheels, pip packages, and system applications as specified in your `default.sh` script.

---

## Configuration Steps

### Adding Custom Nodes

Update the `NODES` array in `config/provisioning/default.sh`:

```bash
NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    # Add more node repositories as needed
)
```

### Installing Prebuilt Wheels

Add prebuilt wheels in the `PIP_PACKAGES` array in `config/provisioning/default.sh`:

```bash
WHEEL_PATHS=(
    "path/to/prebuilt_wheel1.whl"
    "path/to/prebuilt_wheel2.whl"
    # Add more prebuilt wheels as needed
)
```

### Installing Custom Pip Packages

Include custom pip packages in the `PIP_PACKAGES` array:

```bash
PIP_PACKAGES=(
    "package-1"
    "package-2"
    # Add more pip packages as needed
)
```

### Installing Linux System Packages

Specify the apps to be installed on the Linux system in the `APT_PACKAGES` array:

```bash
APT_PACKAGES=(
    "package-1"
    "package-2"
    # Add more system packages as needed
)
```

### 2. Manage Model Downloads for Cloud Deployments
Specify model downloads in `build/COPY_ROOT_99/opt/ai-dock/bin/build/layer99/init.sh` if they should be integrated in the image (in `/config/provisioning/default.sh` if they should be downloaded during container deployment):

```bash
CHECKPOINT_MODELS=(
    "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
    # More models here...
)
```

Run [ComfyUI](https://github.com/comfyanonymous/ComfyUI) in a highly-configurable, cloud-first AI-Dock container.

>[!NOTE]
>These images do not bundle models or third-party configurations. You should use a [provisioning script](https://github.com/ai-dock/base-image/wiki/4.0-Running-the-Image#provisioning-script) to automatically configure your container. You can find examples in `config/provisioning`.

## Documentation

All AI-Dock containers share a common base which is designed to make running on cloud services such as [vast.ai](https://link.ai-dock.org/vast.ai) as straightforward and user friendly as possible.

Common features and options are documented in the [base wiki](https://github.com/ai-dock/base-image/wiki) but any additional features unique to this image will be detailed below.

#### Version Tags

The `:latest` tag points to `:latest-cuda` and will relate to a stable and tested version.  There may be more recent builds

Tags follow these patterns:

##### _CUDA_
- `:cuda-[x.x.x-base|runtime]-[ubuntu-version]`

##### _ROCm_
- `:rocm-[x.x.x-runtime]-[ubuntu-version]`

##### _CPU_
- `:cpu-[ubuntu-version]`


Browse [ghcr.io](https://github.com/ai-dock/comfyui/pkgs/container/comfyui) for an image suitable for your target environment. Alternatively, view a select range of [CUDA](https://hub.docker.com/r/aidockorg/comfyui-cuda) and [ROCm](https://hub.docker.com/r/aidockorg/comfyui-rocm) builds at DockerHub.


Supported Platforms: `NVIDIA CUDA`, `AMD ROCm`, `CPU`

## Additional Environment Variables

| Variable                 | Description |
| ------------------------ | ----------- |
| `AUTO_UPDATE`            | Update ComfyUI on startup (default `false`) |
| `CIVITAI_TOKEN`          | Authenticate download requests from Civitai - Required for gated models |
| `COMFYUI_BRANCH`         | ComfyUI branch/commit hash for auto update (default `master`) |
| `COMFYUI_ARGS`           | Startup flags. eg. `--gpu-only --highvram` |
| `COMFYUI_PORT_HOST`      | ComfyUI interface port (default `8188`) |
| `COMFYUI_URL`            | Override `$DIRECT_ADDRESS:port` with URL for ComfyUI |
| `HF_TOKEN`               | Authenticate download requests from HuggingFace - Required for gated models (SD3, FLUX, etc.) |

See the base environment variables [here](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) for more configuration options.

### Additional Python Environments

| Environment    | Packages |
| -------------- | ----------------------------------------- |
| `comfyui`      | ComfyUI and dependencies |
| `api`          | ComfyUI API wrapper and dependencies |


The `comfyui` environment will be activated on shell login.

~~See the base micromamba environments [here](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software#installed-micromamba-environments).~~

## Additional Services

The following services will be launched alongside the [default services](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software) provided by the base image.

### ComfyUI

The service will launch on port `8188` unless you have specified an override with `COMFYUI_PORT_HOST`.

You can set startup flags by using variable `COMFYUI_ARGS`.

To manage this service you can use `supervisorctl [start|stop|restart] comfyui`.


### ComfyUI API Wrapper

This service is available on port `8188` and is a work-in-progress to replace previous serverless handlers which have been depreciated; Old Docker images and sources remain available should you need them.

You can access the api directly at `/ai-dock/api/` or you can use the Swager/openAPI playground at `/ai-dock/api/docs`.

>[!NOTE]
>All services are password protected by default. See the [security](https://github.com/ai-dock/base-image/wiki#security) and [environment variables](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) documentation for more information.

## Pre-Configured Templates

**Vast.​ai**

- [comfyui:latest-cuda](https://link.ai-dock.org/template-vast-comfyui)

- [comfyui:latest-rocm](https://link.ai-dock.org/template-vast-comfyui-rocm)

---

_The author ([@robballantyne](https://github.com/robballantyne)) may be compensated if you sign up to services linked in this document. Testing multiple variants of GPU images in many different environments is both costly and time-consuming; This helps to offset costs_

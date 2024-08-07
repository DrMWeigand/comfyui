#!/bin/bash

# This file will be sourced in init.sh

# https://raw.githubusercontent.com/ai-dock/comfyui/main/config/provisioning/default.sh

# Packages are installed after nodes so we can fix them...

#DEFAULT_WORKFLOW="https://..."

CONFIG_JSON="/opt/ai-dock/bin/build/layer0/config.json"

#DEFAULT_WORKFLOW="https://..."

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    #"https://github.com/ltdrdata/ComfyUI-Manager"
)

CHECKPOINT_MODELS=(
    #"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"
)

LORA_MODELS=(
    #"https://civitai.com/api/download/models/16576"
)

VAE_MODELS=(
    #"https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

ESRGAN_MODELS=(
    #"https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    #"https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    #"https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
)

CONTROLNET_MODELS=(
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors"
    #"https://huggingface.co/kohya-ss/ControlNet-diff-modules/resolve/main/diff_control_sd15_depth_fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_hed-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_mlsd-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_normal-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_scribble-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_color-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_depth-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_keypose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_sketch-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_style-fp16.safetensors"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    echo "Provisioning container..."
    if [[ ! -d /opt/environments/python ]]; then 
        export MAMBA_BASE=true
    fi
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh comfyui    
    DISK_GB_AVAILABLE=$(($(df --output=avail -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_USED=$(($(df --output=used -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_ALLOCATED=$(($DISK_GB_AVAILABLE + $DISK_GB_USED))
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_create_symlinks
    provisioning_nodes_from_json
    build_extra_copy_file_nodes
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/ckpt" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function pip_install() {
    if [[ -z $MAMBA_BASE ]]; then
        "$COMFYUI_VENV_PIP" install --no-cache-dir "$@"
    else
        micromamba run -n comfyui pip install --no-cache-dir "$@"
    fi
}

function provisioning_create_symlinks() {
    # Source the mappings.sh file to load the storage_map
    declare -A storage_map
    storage_map["stable_diffusion/models/ckpt"]="/opt/ComfyUI/models/checkpoints"
    storage_map["stable_diffusion/models/clip"]="/opt/ComfyUI/models/clip"
    storage_map["stable_diffusion/models/clip_vision"]="/opt/ComfyUI/models/clip_vision"
    storage_map["stable_diffusion/models/controlnet"]="/opt/ComfyUI/models/controlnet"
    storage_map["stable_diffusion/models/diffusers"]="/opt/ComfyUI/models/diffusers"
    storage_map["stable_diffusion/models/embeddings"]="/opt/ComfyUI/models/embeddings"
    storage_map["stable_diffusion/models/facedetection"]="/opt/ComfyUI/models/facedetection"
    storage_map["stable_diffusion/models/facerestore"]="/opt/ComfyUI/models/facerestore_models"
    storage_map["stable_diffusion/models/esrgan"]="/opt/ComfyUI/models/upscale_models"
    storage_map["stable_diffusion/models/gligen"]="/opt/ComfyUI/models/gligen"
    storage_map["stable_diffusion/models/hypernetworks"]="/opt/ComfyUI/models/hypernetworks"
    storage_map["stable_diffusion/models/insightface"]="/opt/ComfyUI/models/insightface"
    storage_map["stable_diffusion/models/ipadapter"]="/opt/ComfyUI/models/ipadapter"
    storage_map["stable_diffusion/models/lora"]="/opt/ComfyUI/models/loras"
    #storage_map["stable_diffusion/models/reactor"]="/opt/ComfyUI/models/reactor"
    storage_map["stable_diffusion/models/stablesr"]="/opt/ComfyUI/models/stablesr"
    storage_map["stable_diffusion/models/style_models"]="/opt/ComfyUI/models/style_models"
    storage_map["stable_diffusion/models/ultralytics"]="/opt/ComfyUI/models/ultralytics"
    storage_map["stable_diffusion/models/unet"]="/opt/ComfyUI/models/unet"
    storage_map["stable_diffusion/models/vae"]="/opt/ComfyUI/models/vae"
    storage_map["stable_diffusion/models/vae_approx"]="/opt/ComfyUI/models/upscale_models"
    storage_map["stable_diffusion/models/comfy3dpack/wonder3d/image_encoder/pytorch_model.bin"]="/opt/ComfyUI/custom_nodes/ComfyUI-3D-Pack/Checkpoints/flamehaze1115/wonder3d-v1.0/image_encoder/pytorch_model.bin"
    storage_map["stable_diffusion/models/comfy3dpack/wonder3d/unet/diffusion_pytorch_model.bin"]="/opt/ComfyUI/custom_nodes/ComfyUI-3D-Pack/Checkpoints/flamehaze1115/wonder3d-v1.0/unet/diffusion_pytorch_model.bin"
    storage_map["stable_diffusion/models/comfy3dpack/wonder3d/vae/diffusion_pytorch_model.bin"]="/opt/ComfyUI/custom_nodes/ComfyUI-3D-Pack/Checkpoints/flamehaze1115/wonder3d-v1.0/vae/diffusion_pytorch_model.bin"
    storage_map["stable_diffusion/models/comfy3dpack/crm"]="/opt/ComfyUI/custom_nodes/ComfyUI-3D-Pack/Checkpoints/CRM"
    storage_map["stable_diffusion/models/comfy3dpack/lgm"]="/opt/ComfyUI/custom_nodes/ComfyUI-3D-Pack/Checkpoints/LGM"
    storage_map["stable_diffusion/models/comfy3dpack/tsr"]="/opt/ComfyUI/custom_nodes/ComfyUI-3D-Pack/Checkpoints/TripoSR"
    storage_map["stable_diffusion/models/comfy3dpack/StableFast3D"]="/opt/ComfyUI/custom_nodes/ComfyUI-3D-Pack/Checkpoints/StableFast3D"
    for src in "${!storage_map[@]}"; do
        target="${storage_map[$src]}"
        src_path="${WORKSPACE}storage/${src}"

        # Check if the target already exists and is not a symbolic link
        if [[ -e "$target" && ! -L "$target" ]]; then
            echo "Removing existing directory (not a symlink): $target"
            rm -rf "$target"
        fi

        # Create the symlink, no action if already exists
        echo "Creating symlink: $src_path -> $target"
        ln -sfn "$src_path" "$target"
    done
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
        sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
        pip_install ${PIP_PACKAGES[@]}
    fi
}

# Modified function to download and checkout specific node commits
function provisioning_nodes_from_json() {
    # Load nodes from JSON and iterate
    for node in $(jq -c '.git_custom_nodes | to_entries[]' $CONFIG_JSON); do
        repo=$(echo $node | jq -r '.key')
        hash=$(echo $node | jq -r '.value.hash')
        disabled=$(echo $node | jq -r '.value.disabled')

        if [[ $disabled == "true" ]]; then
            echo "Skipping disabled node: $repo"
            continue
        fi

        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"

        if [[ -d $path ]]; then
            if [[ $hash != null ]]; then
                echo "Updating node: $repo to commit $hash"
                ( cd "$path" && git fetch && git checkout $hash )
                if [[ -e $requirements ]]; then
                    micromamba -n comfyui run ${PIP_INSTALL} -r "$requirements"
                fi
            fi
        else
            echo "Downloading and checking out node: $repo to commit $hash"
            git clone "${repo}" "${path}" --recursive
            ( cd "$path" && git checkout $hash )
            if [[ -e $requirements ]]; then
                micromamba -n comfyui run ${PIP_INSTALL} -r "${requirements}"
            fi
        fi
    done
}

function build_extra_copy_file_nodes() {
    jq -c '.file_custom_nodes[]' $CONFIG_JSON | while read node; do
        filename=$(echo $node | jq -r '.filename')
        disabled=$(echo $node | jq -r '.disabled')

        if [[ $disabled == "true" ]]; then
            echo "Skipping disabled file node: $filename"
            continue
        fi

        # Define the source and destination paths
        src="/opt/ai-dock/bin/extra_nodes/${filename}"
        dest="/opt/ComfyUI/custom_nodes/${filename}"

        if [[ -f $src ]]; then
            echo "Copying file node: $filename"
            cp $src $dest
        else
            echo "File node $filename does not exist at $src"
        fi
    done
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip_install -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip_install -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_default_workflow() {
    if [[ -n $DEFAULT_WORKFLOW ]]; then
        workflow_json=$(curl -s "$DEFAULT_WORKFLOW")
        if [[ -n $workflow_json ]]; then
            echo "export const defaultGraph = $workflow_json;" > /opt/ComfyUI/web/scripts/defaultGraph.js
        fi
    fi
}
function provisioning_get_default_workflow() {
    if [[ -n $DEFAULT_WORKFLOW ]]; then
        workflow_json=$(curl -s "$DEFAULT_WORKFLOW")
        if [[ -n $workflow_json ]]; then
            echo "export const defaultGraph = $workflow_json;" > /opt/ComfyUI/web/scripts/defaultGraph.js
        fi
    fi
}

function provisioning_get_models() {
    if [[ -z $2 ]]; then return 1; fi
    dir="$1"
    mkdir -p "$dir"
    shift
    if [[ $DISK_GB_ALLOCATED -ge $DISK_GB_REQUIRED ]]; then
        arr=("$@")
    else
        printf "WARNING: Low disk space allocation - Only the first model will be downloaded!\n"
        arr=("$1")
    fi
    
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

provisioning_start

#!/bin/bash

# Use this layer to add nodes and models

CONFIG_JSON="/opt/ai-dock/bin/build/layer0/standard_config.json"

APT_PACKAGES=(
    cuda-toolkit-12-1
    pkg-config
    libglvnd0
    libgl1
    libglx0
    libegl1
    libgles2
    libglvnd-dev
    libgl1-mesa-dev
    libegl1-mesa-dev
    libgles2-mesa-dev
    cmake
    #"package-1"
    #"package-2"
)

# Packages are installed after nodes so we can fix them...
PIP_PACKAGES=(
    torch-scatter -f https://data.pyg.org/whl/torch-2.3.0+cu121.html
#    "xformers"
#    "rembg"
)

WHEEL_PATHS=(
   "Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_linux_py311_cu121/diff_gaussian_rasterization-0.0.0-cp311-cp311-linux_x86_64.whl"
   "Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_linux_py311_cu121/kiui-0.2.10-py3-none-any.whl"
   "Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_linux_py311_cu121/nvdiffrast-0.3.1-py3-none-any.whl"
   "Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_linux_py311_cu121/pointnet2_ops-3.0.0-cp311-cp311-linux_x86_64.whl"
   "Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_linux_py311_cu121/pointnet2_ops-3.0.0-cp311-cp311-linux_x86_64.whl"
   "Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_linux_py311_cu121/pytorch3d-0.7.7-cp311-cp311-linux_x86_64.whl"
   "Comfy3D_Pre_Builds/_Build_Wheels/_Wheels_linux_py311_cu121/simple_knn-0.0.0-cp311-cp311-linux_x86_64.whl"
)

LOCAL_REPOS=(
#    "ComfyUI-3D-Pack/tgs/models/snowflake/pointnet2_ops_lib"
#    "ComfyUI-3D-Pack/simple-knn"
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/WASasquatch/was-node-suite-comfyui"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/Jcd1230/rembg-comfyui-node"
    "https://github.com/MrForExample/Comfy3D_Pre_Builds"    
    "https://github.com/MrForExample/ComfyUI-3D-Pack"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack"
    "https://github.com/edenartlab/eden_comfy_pipelines"
)

CHECKPOINT_MODELS=(
    #"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"
)

UNET_MODELS=(

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

function build_extra_start() {
    build_extra_get_apt_packages
    build_extra_get_nodes
    provisioning_nodes_from_json
    build_extra_copy_file_nodes    
    build_extra_get_pip_packages
    build_extra_install_local_repos
    build_extra_install_prebuilt_wheels
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/ckpt" \
        "${CHECKPOINT_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/unet" \
        "${UNET_MODELS[@]}"        
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/lora" \
        "${LORA_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
     
    cd /opt/ComfyUI
    source "$COMFYUI_VENV/bin/activate"
    LD_PRELOAD=libtcmalloc.so python main.py \
        --cpu \
        --listen 127.0.0.1 \
        --port 11404 \
        --disable-auto-launch \
        --quick-test-for-ci
    deactivate
}

function build_extra_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                    "$COMFYUI_VENV_PIP" install --no-cache-dir \
                        -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                "$COMFYUI_VENV_PIP" install --no-cache-dir \
                    -r "${requirements}"            
                    fi
        fi
    done
}

function build_extra_get_apt_packages() {
    if [ ${#APT_PACKAGES[@]} -gt 0 ]; then
        $APT_INSTALL ${APT_PACKAGES[*]}
    fi
}
function build_extra_get_pip_packages() {
    if [ ${#PIP_PACKAGES[@]} -gt 0 ]; then
        "$COMFYUI_VENV_PIP" install --no-cache-dir \
            ${PIP_PACKAGES[*]}
    fi
}

function build_extra_get_models() {
    if [[ -n $2 ]]; then
        dir="$1"
        mkdir -p "$dir"
        shift
        arr=("$@")
        
        printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
        for url in "${arr[@]}"; do
            printf "Downloading: %s\n" "${url}"
            build_extra_download "${url}" "${dir}"
            printf "\n"
        done
    fi
}

function build_extra_install_prebuilt_wheels() {
    local base_path="/opt/ComfyUI/custom_nodes"
    echo "Installing prebuilt wheels..."
    # Assume WHEEL_PATHS is an array like ("RepoName1/PathToWheels/Wheel1.whl" "RepoName2/PathToWheels/Wheel2.whl")
    for wheel_path in "${WHEEL_PATHS[@]}"; do
        local full_path="${base_path}/${wheel_path}"
        if [[ -f "$full_path" ]]; then
            echo "Installing wheel: $full_path"
            "$COMFYUI_VENV_PIP" install --no-cache-dir \
            "$full_path"
        else
            echo "Wheel file not found: $full_path"
        fi
    done
}

function build_extra_install_local_repos() {
    local base_path="/opt/ComfyUI/custom_nodes"
    echo "Installing local repositories..."
    # Assume LOCAL_REPOS is an array like ("RepoName1/path/to/repo1" "RepoName2/path/to/repo2")
    for repo_path in "${LOCAL_REPOS[@]}"; do
        local full_path="${base_path}/${repo_path}"
        if [[ -d "$full_path" ]]; then
            echo "Installing local repository: $full_path"
            (cd "$full_path" && "$COMFYUI_VENV_PYTHON" run python setup.py install)
        else
            echo "Local repository not found: $full_path"
        fi
    done
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
                    "$COMFYUI_VENV_PIP" install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            echo "Downloading and checking out node: $repo to commit $hash"
            git clone "${repo}" "${path}" --recursive
            ( cd "$path" && git checkout $hash )
            if [[ -e $requirements ]]; then
                "$COMFYUI_VENV_PIP" install --no-cache-dir -r "${requirements}"
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

# Download from $1 URL to $2 file path
function build_extra_download() {
    wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
}

umask 002

build_extra_start
fix-permissions.sh -o container
#!/usr/bin/env bash
set -eou pipefail

mkdir -p images
rm -f images/*

# versions has type and git tag
# build script knows how to build based on type

# 0.55 can't find Makefile.in
#configure-add-unistd uncrustify-0.55
VERSIONS=$(cat <<EOF
configure-add-unistd uncrustify-0.54
configure-add-unistd uncrustify-0.56
configure-add-unistd uncrustify-0.57
configure-add-unistd uncrustify-0.58
configure-add-unistd uncrustify-0.59
configure uncrustify-0.60
configure uncrustify-0.61
configure uncrustify-0.62
autogen uncrustify-0.63
cmake uncrustify-0.64
cmake uncrustify-0.65
cmake uncrustify-0.66
cmake-add-stdexcept uncrustify-0.66.1
cmake uncrustify-0.67
cmake uncrustify-0.68
cmake uncrustify-0.68.1
cmake uncrustify-0.69.0
cmake uncrustify-0.70.0
cmake uncrustify-0.70.1
cmake uncrustify-0.71.0
cmake uncrustify-0.72.0
cmake uncrustify-0.73.0
EOF
)

# Default docker image
DOCKER_IMAGE="alpine:3.14"

DEFAULT_TEMPLATE="Dockerfile.template"
AUTOGEN_TEMPLATE="Dockerfile.autogen.template"

# Create a Dockerfile from template
_create() {
    dockerfile="$1"
    buildType="$2"
    tag="$3"
    image="$4"
    template="$5"

    cp -a "$template" "$dockerfile"
    sed -i "s/{tag}/$tag/g"               "$dockerfile"
    sed -i "s/{buildType}/$buildType/g"   "$dockerfile"
    sed -i "s/{image}/$image/g"           "$dockerfile"
}

# Get latest version
latest=$(<<< "${VERSIONS}" tail -n1 | awk '{print $NF}')

# Create Dockerfiles for the new versions
while read -r line; do
    buildType=${line// uncrustify-*/}
    tag=${line//* uncrustify-/uncrustify-}
    ver=${line//* uncrustify-/}

    if [[ "$buildType" == "autogen" ]]; then
        template=$AUTOGEN_TEMPLATE
    else
        template=$DEFAULT_TEMPLATE
    fi

    dockerfile="images/${ver}-Dockerfile"
    _create "$dockerfile" "$buildType" "${tag}" "${DOCKER_IMAGE}" "${template}"

  # Copy Dockerfile for latest version
  if [ "$tag" == "$latest" ]; then
      cp "$dockerfile" "./images/latest-Dockerfile"
  fi
done <<< "$VERSIONS"

_create "images/dev-Dockerfile" "cmake" "master" "${DOCKER_IMAGE}" "${DEFAULT_TEMPLATE}"

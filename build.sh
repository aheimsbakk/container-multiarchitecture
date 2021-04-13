#!/bin/sh

# convert docker architecture to qemu architecture
get_arch2arch() {
  arch="$1"

  case "$arch" in
    amd64) echo amd64 ;;
    arm64v8) echo aarch64 ;;
    arm32v7) echo arm ;;
    arm32v6) echo arm ;;
    *) exit 1;;
  esac
}

# get qemu container for architecture
get_multiarch_qemu_container() {
  arch="$(get_arch2arch "$1")"

  [ "$arch" != "amd64" ] &&
    echo "FROM docker.io/multiarch/qemu-user-static:x86_64-$arch as qemu"
}

# get the content of the dockerfile
get_dockerfile() {
  arch="$1"; shift
  dockerfile="$1"

  if [ "$arch" != "amd64" ]
  then
    sed "s#docker.io/#docker.io/$arch/#g" "$dockerfile" |
      sed "/^FROM /a COPY --from=qemu /usr/bin/qemu-$(get_arch2arch "$arch")-static /usr/bin" |
      sed "0,/FROM /!b;//i $(get_multiarch_qemu_container "$arch")\n"
  else
    cat "$dockerfile"
  fi
}

### main

ARCHITECTURES="amd64 arm64v8 arm32v7"
tag="${1:-build:latest}"

# allow multiarch
sudo podman run --rm --privileged docker.io/multiarch/qemu-user-static --reset

# build for all architectures
for arch in $ARCHITECTURES
do
  echo
  echo %%
  echo %% BUILDING FOR ARCHITECTURE = "$arch" =
  echo %%
  echo

  get_dockerfile "$arch" "Dockerfile"  |
    podman build --tag "$tag-$arch" --file -

  #get_dockerfile "$arch" "Dockerfile" | cat
done


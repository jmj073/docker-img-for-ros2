# X11 & GPU용 이미지

X11과 GPU 사용을 같이하는 방법. [여기](https://roboticseabass.com/2021/04/21/docker-and-ros/)를 참고하였다. rviz라거나 gazebo와 같이 (아마도?)openGL을 사용하는 프로그램을 실행할 수 있다.

gpu를 사용하기 위해서는 `docker run` command에서 `--gpus all`을 지정해줘야 하는데, macOS에서는 이것이 불가능한 듯 하다([참고](https://stackoverflow.com/questions/46367517/can-i-use-my-gpu-from-a-docker-container-on-a-macbook-pro-amd-radeon-gpu)). nvidia gpu가 있는 wsl2 docker에서는 동작되는 것을 확인하였다.

한가지 특징은 `DISPLAY` 환경 변수가 `host.docker.internal:0`가 아니라 docker를 실행하는 환경의 `DISPLAY` 환경 변수를 그대로 넘긴다는 점이다. 이 둘의 차이점은, 내가 확인한 바로는, 전자는 wsl2 docker에서 실행시켰을때, window 환경에 X11 server가 실행중이어야 한다는 점이다. 따라서 창의 테두리가 windows 11과 같은것을 볼 수 있다. 후자는 해당 X11 server의 실행이 필요 없으며, wsl2 내의 X11을 사용하는 듯 하다. 이때는 아래에 나와있는 command와 같이 `--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"`가 필요한 듯 하다. 또한 창의 테두리가 wsl2에서 `xcalc`등을 실행시켰을 때와 같은것을 볼 수 있다. 또한 rviz나 gazebo같은 것을 후자에서만 동작했다. `--gpus all`을 빼도 동작했다. 이유는 잘 모르겠다.

```shell
docker run -it --network=host --gpus all \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    "$@" \
    osrf/ros:humble-desktop \
    bash

```
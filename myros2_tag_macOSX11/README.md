# macOS와 Xquartz(X11)용 이미지

Xquartz는 gui 프로그램을 실행시키기 위해 필요하다. Xquartz는 macOS 용이다. 자세한건 [여기](https://desertbot.io/blog/ros-turtlesim-beginners-guide-mac)를 참고하자. 간단하게 말하자면 대충 이렇다:

1. 인터넷에서 xquartz 설치
2. **terminal에서 `xhost + 127.0.0.1` 실행.**
3. docker container의 환경 변수에 `DISPLAY=host.docker.internal:0` 추가.

## 빌드

```shell
docker build -t 'myros2:macOSX11' .
# 또는
docker build -t 'jmj073/myros2:macOSX11' .
```

## 실행

+ `myros2:macOSX11`로 실행시에는 img에 DISPLAY 환경 변수가 들어 있으므로 다음처럼 하면 된다.

  ```
  docker run -it jmj073/myros2:macOSX11 bash
  docker exec -it <container-id> /ros_entrypoint.sh bash
  ```

+ `osrf/ros:humble-desktop`로 실행시에는 환경변수를 설정해줘야 한다.

  ```
  docker run -it -e DISPLAY=host.docker.internal:0 -e LIBGL_ALWAYS_INDIRECT=1 osrf/ros:humble-desktop bash
  docker exec -it <container-id> /ros_entrypoint.sh bash
  ```

  또는 `run.sh` 실행.

## Dockerfile 설명

```dockerfile
FROM osrf/ros:humble-desktop
```

base이미지를 ros humble distribution으로 설정.

---

```Dockerfile
ENV DISPLAY=host.docker.internal:0
ENV LIBGL_ALWAYS_INDIRECT=1
```

+ `DISPLAY=host.docker.internal:0`: DISPLAY 환경 변수는 Xquartz에 디스플레이 명령을 보내는 포인터를 생성. [참고](https://desertbot.io/blog/ros-turtlesim-beginners-guide-mac)

+ `LIBGL_ALWAYS_INDIRECT=1`: 이걸 넣지 않으면 gui프로그램을 실행시켰을 때 아래와 같은 오류메시지가 표시된다. 하지만 오류로인해 프로그램이 제대로 동작되지 않은 경우는 아직 없었다. [참고](https://askubuntu.com/questions/1127011/win10-linux-subsystem-libgl-error-no-matching-fbconfigs-or-visuals-found-libgl)

  ```
  libGL error: No matching fbConfigs or visuals found
  libGL error: failed to load driver: swrast
  ```

## display를 설정하지 않았을 시에 gui 프로그램을 실행시키면

```
qt.qpa.xcb: could not connect to display
qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.

Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vnc, xcb.

[ros2run]: Aborted
```


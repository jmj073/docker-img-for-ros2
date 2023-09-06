#!/bin/bash

docker run -it -e DISPLAY=host.docker.internal:0 -e LIBGL_ALWAYS_INDIRECT=1 "$@" osrf/ros:humble-desktop bash

### Dockerfile for a general-purpose C++ container
### 
### For a multi-stage Dockerfile like we have here, we can select which stage/ target we want
### to use for our resultant image:
###
### $> docker build -t IMAGE_NAME --target TARGET_NAME .
###
### We can subsequently run a container using that image as follows:
###
### $> docker run -it --rm --name CONTAINER_NAME IMAGE_NAME (/bin/sh)
###
### the optional part in parentheses letting us get access to the container's shell.
FROM debian:latest AS base

# Development environment; what we need to build, but also for things like Intellisense
# to work properly
FROM base AS dev
RUN apt-get -y update && apt-get install -y
RUN apt-get -y install gcc g++
RUN apt-get -y install libgtest-dev libgmock-dev

# Build environment; could use a volume here, but keep things separate
FROM dev AS build
WORKDIR /app
COPY src/ src/
COPY test/ test/
COPY include/ include/

# Create the test binary -- substitute for build system
FROM build AS test
RUN g++ -std=c++17 -Iinclude -Itest src/mockable.cc test/mock_mockable.cc test/test_mockable.cc -o test.x -lpthread -lgtest -lgmock -lgtest_main

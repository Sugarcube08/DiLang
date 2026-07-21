cmake_minimum_required(VERSION 3.18)
project(dilang_native_sdk VERSION 1.0.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(include)

# Placeholder C++ native implementation library
add_library(dilang_native_sdk SHARED
    src/dilang_native_sdk.cpp
)

set_target_properties(dilang_native_sdk PROPERTIES
    PUBLIC_HEADER include/dilang_native_sdk.h
)

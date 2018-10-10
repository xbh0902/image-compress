cmake_minimum_required(VERSION 3.10)
project(image_rectification_demo)

set(CMAKE_CXX_STANDARD 11)
set(OpenCV_DIR D:/Evn/opencv)
aux_source_directory(${CMAKE_SOURCE_DIR}/test/ SOURCE_DIR)

include_directories(test/include/)

add_executable(image_rectification_demo ${SOURCE_DIR})

find_package(OpenCV REQUIRED)

message(STATUS "OpenCV library status:")
message(STATUS "version: ${OpenCV_VERSION}")
message(STATUS "libraries: ${OpenCV_LIBS}")
message(STATUS "include path: ${OpenCV_INCLUDE_DIRS}")

if (OpenCV_FOUND)
    set(OpenCV_LIBS
            opencv_core
            opencv_imgproc
            opencv_highgui
            opencv_imgcodecs
            )
    target_link_libraries(image_rectification_demo ${OpenCV_LIBS})
endif ()
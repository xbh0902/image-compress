cmake_minimum_required(VERSION 3.10)
project(image_rectification_demo)

project(image-compress)
aux_source_directory(${CMAKE_SOURCE_DIR}/image-compress/src/ SOURCE_DIR)
include_directories(image-compress/src/include/
        image-compress/include/libgd/)

add_executable(image-compress ${SOURCE_DIR})

add_library(libgd STATIC IMPORTED)
set_target_properties(libgd PROPERTIES IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/image-compress/libs/liblibgd.a)
target_link_libraries(image-compress
                     libgd)
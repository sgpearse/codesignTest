cmake_minimum_required (VERSION 3.17)

project (codesignTest)
add_definitions (-DDarwin)

set(CMAKE_EXPORT_COMPILE_COMMANDS   ON)
set(CMAKE_CXX_STANDARD              11)
set(CMAKE_CXX_FLAGS                 "${CMAKE_CXX_FLAGS} -Wall -Wno-sign-compare -Wno-overloaded-virtual -Wno-parentheses")
set(CMAKE_C_FLAGS                   "${CMAKE_C_FLAGS} -Wall -Wno-sign-compare")
set(CMAKE_OSX_DEPLOYMENT_TARGET     "12.0" CACHE STRING "Minimum OS X deployment version" FORCE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY  ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_INSTALL_PREFIX            /Applications)

set (BUILD_WITH_INSTALL_RPATH "@executable_path/../lib")

add_executable(codesignTest codesignTest.cpp)
install(
    TARGETS codesignTest
    DESTINATION ./${PROJECT_NAME}.app/Contents/MacOS
    COMPONENT Utilities
)

###############################################################################
#                            CPack Installation                               #
###############################################################################

set (CPACK_PACKAGE_NAME              ${PROJECT_NAME})
set (CPACK_PACKAGE_EXECUTABLES       codesignTest)
set (CPACK_BINARY_DRAGNDROP          ON)
set (CPACK_BINARY_STGZ               OFF)
set (CPACK_BINARY_TGZ                OFF)
set (CPACK_BINARY_TZ                 OFF)

# Modify our codesigning script to reference local 
# environment variable $CMAKE_RUNTIME_OUTPUT_DIRECTORY
set(CODESIGN_RAW_SCRIPT     "${CMAKE_SOURCE_DIR}/macCodeSign.cmake")
set(CODESIGN_UPDATED_SCRIPT "${CMAKE_SOURCE_DIR}/macCodeSign_updated.cmake")
configure_file( 
    ${CODESIGN_RAW_SCRIPT} 
    ${CODESIGN_UPDATED_SCRIPT} 
    @ONLY
)

# Configure our modified codesigning script to run during "make install"
set(CPACK_INSTALL_SCRIPTS ${CODESIGN_UPDATED_SCRIPT})

include (CPack)
add_custom_target (
    installer
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    COMMAND cpack .
)

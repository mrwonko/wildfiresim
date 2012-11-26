cmake_minimum_required(VERSION 2.6)

# name + language
project(WildFireSim CXX)

set(SOURCE_FILES
	"src/main.cpp"
	"src/jar/Lua.cpp"
	"src/jar/LuabindSFMLDrawable.cpp"
	"src/jar/LuabindSFMLImage.cpp"
	"src/jar/LuabindSFMLMath.cpp"
	"src/jar/LuabindSFMLShape.cpp"
	"src/jar/LuabindSFMLSprite.cpp"
	"src/jar/LuabindSFMLString.cpp"
	"src/jar/LuabindSFMLWindowStuff.cpp"
	)
set(HEADER_FILES
	"include/jar/Lua.h"
	"include/jar/LuabindSFML.h"
	)

add_executable(WildFireSim ${SOURCE_FILES} ${HEADER_FILES})

# enable all warnings
add_definitions(-Wall)

# add make_modules directory to module path
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake_modules" ${CMAKE_MODULE_PATH})

# search SFML and Lua modules
find_package(SFML 2 REQUIRED system window graphics)
find_package(Lua51 REQUIRED)

# set include directories
include_directories("${CMAKE_SOURCE_DIR}/include" ${SFML_INCLUDE_DIR} ${LUA_INCLUDE_DIR})
# set link targets
target_link_libraries(WildFireSim ${SFML_LIBRARIES} ${LUA_LIBRARY})

install(TARGETS WildFireSim DESTINATION "${CMAKE_SOURCE_DIR}/bin")
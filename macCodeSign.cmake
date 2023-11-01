file( GLOB MY_FILES_TO_SIGN @CMAKE_RUNTIME_OUTPUT_DIRECTORY@/* )
execute_process(COMMAND echo My Files ${MY_FILES_TO_SIGN})
execute_process(COMMAND codesign --force --verbose=2 --sign "DQ4ZFL4KLF" ${MY_FILES_TO_SIGN})
execute_process(COMMAND codesign -dv --verbose=2 ${MY_FILES_TO_SIGN})
# $(CODESIGN) --force --verbose=2 --sign "$(TEAM_ID)" ./dist/MyMacOSApp-0.1.1-Darwin.dmg

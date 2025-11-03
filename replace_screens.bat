@echo off
rem Backup original files
move "lib\sabah_massae.dart" "lib\sabah_massae.dart.bak"
move "lib\a3ibadat.dart" "lib\a3ibadat.dart.bak"

rem Move new versions to replace originals
move "lib\sabah_massae_new.dart" "lib\sabah_massae.dart"
move "lib\a3ibadat_new.dart" "lib\a3ibadat.dart"
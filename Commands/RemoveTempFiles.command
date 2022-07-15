#! /bin/bash
set -eu

# Переходим на текущую директорию 
dir="`dirname \"$0\"`"

# Получаем директорию проекта, "cd -" работает не корректно, поэтому стираем названием директории в которой находится скрипт. Если скрипт находится не в /Commands, ниже нужно указать нужный путь
dir=${dir%"/Commands"}

# Переходим в директорию проекта 
# echo "cd-ing to $dir"
cd "$dir" || exit 1

# Удаляем xcodeproj
rm -r *.xcodeproj
# Удаляем xcworkspace
rm -r *.xcworkspace
# Удаляем Podfile.lock
rm -r Podfile.lock
# Рекурсивно удаляем все файлы с директории Pods
rm -rf Pods

exit 0
#! /bin/bash
set -eu

# Переходим на текущую директорию 
dir="`dirname \"$0\"`"
cd "$dir" || exit 1
cd ..

# Ищем все существующий директории внутри проекта 
for f in *; do
    # Проверяем, что это действительно директория
    if [ -d "$f" ]; 
	then
	# Путь до файла c генерацией
        path="$f"/Sources/Generated
	# Проверяем наличие директории
	if [ -d $path ]
	then
	     filePath="$path"/R.generated.swift
   	     # Проверяем наличие файла R.generated.swift, если его нет, то создаем 
	     if [ -f $filePath ]
	     	then
		     echo "R.generated exist"
		else 
		     echo "Create R.generated"
		     echo >${path}/R.generated.swift
	     fi
	fi
    fi
done

#rootFolderPath=$(git rev-parse --show-toplevel)
#hooksFolderPath="$rootFolderPath"/.git/hooks
#postCheckoutFilePath="$rootFolderPath"/Uniq/Commands/post-checkout
   
#if ! [ -d "$hooksFolderPath" ]; 
#   then 
#   echo "Create git hook"
#   mkdir -p "$hooksFolderPath"
#   ln -s -f $postCheckoutFilePath $hooksFolderPath
#   else
#   echo "git hook exist"
#fi

#Запускаем генерацию проекта 
eval "xcodegen generate"
#Запускаем установку pod-ов 
eval "pod install"
# Установка VIP templates
eval "sh .install_templates.sh"
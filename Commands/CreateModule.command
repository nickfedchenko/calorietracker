dir="`dirname \"$0\"`"
cd "$dir" || exit 1
cd ..
cd VIPGenerator
echo "the PWD is : ${PWD}"
echo "Enter module name"
read moduleName
echo "Enter class prefix"
read classPrefix
eval "./Generator.swift ${moduleName} ${classPrefix}"
eval "mv ${moduleName} ../CalorieTracker/Modules"
cd ..
cd Commands
eval "./Setup.command"
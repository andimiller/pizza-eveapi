#!/bin/sh
mkdir -p src/main/resources/raw/eve
mkdir -p src/main/resources/raw/char
mkdir -p src/main/resources/raw/corp
mkdir -p src/main/resources/raw/account
mkdir -p src/main/resources/raw/map
mkdir -p src/main/resources/raw/server
mkdir -p src/main/resources/xsd/eve
mkdir -p src/main/resources/xsd/char
mkdir -p src/main/resources/xsd/corp
mkdir -p src/main/resources/xsd/account
mkdir -p src/main/resources/xsd/map
mkdir -p src/main/resources/xsd/server
echo "Generating XSD schemas"
for xml in `find src/main/resources/raw -name '*.xml'`;
do
    input=$xml;
    output=`echo $xml | sed 's/raw/xsd/g' | sed 's/\.xml/\.xsd/g'`;
    java -jar util/trang.jar $input $output;
    echo "\t"$xml" -> "$output;
done
echo "Generating namespaces for XSD schemas"
for xsd in `find src/main/resources/xsd -name '*.xsd'`;
do
    p=`echo $xsd | sed 's/.*xsd\//moe.pizza.eveapi.generated./' | sed 's:/:.:' | sed 's/\.xsd$//g'`;
    echo "\t"$p" -> "$xsd;
    java -jar util/scalaxb.jar $xsd -p $p --package-dir --protocol-package $p -d src/main/scala/ | sed 's/^/\t\t/g';
done

# This script is copied from https://github.com/themoeway/yomitan-import/blob/main/scripts/build_dicts.sh with little modifications.

#!/bin/bash

mkdir -p src
mkdir -p dst

current_date=$(date '+%Y-%m-%d')

function refresh_source () {
    NOW=$(date '+%s')
    YESTERDAY=$((NOW - 86400)) # 86,400 seconds in 24 hours
    if [ ! -f "src/$1" ]; then
        wget "ftp.edrdg.org/pub/Nihongo/$1.gz"
        gunzip -c "$1.gz" > "src/$1"
    elif [[ $YESTERDAY -gt $(date -r "src/$1" '+%s') ]]; then
        rsync "ftp.edrdg.org::nihongo/$1" "src/$1"
    fi
}

refresh_source "JMdict_e_examp"
./binaries/yomitan -language="english_extra" -title="JMdict" src/JMdict_e_examp dst/${current_date}_JMdict_english_with_examples.zip

refresh_source "JMdict"
./binaries/yomitan -format="forms"       -title="JMdict Forms"       src/JMdict dst/${current_date}_JMdict_forms.zip

refresh_source "JMnedict.xml"
./binaries/yomitan src/JMnedict.xml dst/${current_date}_JMnedict.zip

refresh_source "kanjidic2.xml"
./binaries/yomitan -language="english"    -title="KANJIDIC"              src/kanjidic2.xml dst/${current_date}_KANJIDIC_english.zip

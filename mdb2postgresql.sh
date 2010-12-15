#!/bin/bash

echo "CREATE SCHEMA source;\n" > $2
mdb-schema -N "source." $1 postgres >> $2
perl -p -i -e 's|DROP TABLE |DROP TABLE IF EXISTS |g' $2
perl -p -i -e 's|BOOL|INTEGER|g' $2

for i in `mdb-tables $1`
do
  echo $i
  echo "BEGIN;\nLOCK TABLE source.\"$i\";\n" >> $2
  mdb-export -I postgres -q \' -N "source." -R "\n" $1 $i >> $2
  echo "COMMIT;\n" >> $2
done

perl -p -i -e 's|\\|\\\\|g' $2

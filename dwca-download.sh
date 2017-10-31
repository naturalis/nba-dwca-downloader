#!/bin/bash

date

SERVER_ADDR_FILE=/tmp/nbabase.txt
#SERVER_ADDR_FILE=/var/www/drupal/sites/default/files/nbabase.txt

if [ ! -f $SERVER_ADDR_FILE ]; then
  echo "$SERVER_ADDR_FILE not found"
  exit
fi

SERVER=$(cat $SERVER_ADDR_FILE | sed -e 's/\/v2[/]*//')
OUTDIR=downloads

datestamp() {
  date +"%Y%m%d"
}

OUT=$(curl -s -XGET $SERVER/v2/specimen/dwca/getDataSetNames)
NAMES=$(echo  $OUT | python3 data_set_names.py)

for i in $NAMES; do
        echo "downloading $i"
        curl -o ${OUTDIR}/tmp-${i}-`datestamp`.dwca.zip.part $SERVER/v2/specimen/dwca/getDataSet/$i
        echo "deleting previous ${i} download"
        rm -f ${OUTDIR}/${i}*
        mv ${OUTDIR}/tmp-${i}-`datestamp`.dwca.zip.part ${OUTDIR}/${i}-`datestamp`.dwca.zip
done


OUT=$(curl -s -XGET $SERVER/v2/taxon/dwca/getDataSetNames)
NAMES=$(echo  $OUT | python3 data_set_names.py)

for i in $NAMES; do
        echo "downloading $i"
        curl -o ${OUTDIR}/tmp-${i}-`datestamp`.dwca.zip.part $SERVER/v2/taxon/dwca/getDataSet/$i
        echo "deleting previous ${i} download"
        rm -f ${OUTDIR}/${i}*
        mv ${OUTDIR}/tmp-${i}-`datestamp`.dwca.zip.part ${OUTDIR}/${i}-`datestamp`.dwca.zip
done

date

echo "done"

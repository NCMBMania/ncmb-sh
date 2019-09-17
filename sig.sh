#!/usr/bin/env bash

for OPT in "$@"
do
    case $OPT in
        '-a' )
            APPLICATION_KEY=$2
            ;;
        '-c' )
            CLIENT_KEY=$2
            ;;
        '-w' )
            WHERE=${2}
            ;;
        '-p' )
            CLASSNAME=$2
            REQ_PATH="/2013-09-01/classes/$CLASSNAME"
            ;;
        '-m' )
            METHOD=$2
            ;;
        '-l' )
            LIMIT=$2
            ;;
        '-s' )
            SKIP=$2
            ;;
    esac
    shift
done

DATE=`date '+%Y-%m-%dT%H:%M:%S%z'`
FQDN="mbaas.api.nifcloud.com"
str="SignatureMethod=HmacSHA256&SignatureVersion=2&X-NCMB-Application-Key=$APPLICATION_KEY&X-NCMB-Timestamp=$DATE"
QUERY=""
if [ ! $LIMIT = "" ]; then
  str="$str&limit=$LIMIT"
  QUERY=" --data-urlencode 'limit=$LIMIT'"
fi
if [ ! $SKIP = "" ]; then
  str="$str&skip=$skip"
  QUERY="$QUERY --data-urlencode 'skip=$SKIP'"
fi
if [ ! $WHERE = "" ]; then
  tmp=`echo ${WHERE} | nkf -WwMQ | tr = %`
  str="$str&where=$tmp"
  QUERY="$QUERY --data-urlencode 'where=$WHERE'"
fi

sigStr=$METHOD"\n"$FQDN"\n"$REQ_PATH"\n"$str

sig=`echo -e -n ${sigStr} | openssl dgst -sha256 -binary -hmac ${CLIENT_KEY} | base64`

cmd="curl -s -S -X GET -G -H \"X-NCMB-Application-Key: ${APPLICATION_KEY}\" \\
 -H \"X-NCMB-Timestamp: ${DATE}\" \\
 -H \"X-NCMB-Signature: ${sig}\" \\
 -H \"Content-Type: application/json\" \\
 ${QUERY} \\
 https://mbaas.api.nifcloud.com${REQ_PATH}"
res=`sh -c "${cmd}"`
echo $res

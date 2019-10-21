#!/usr/bin/env bash

if [[ -f ./.env ]]; then
  . .env
fi

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
            WHERE=$2
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
        '-d' )
            DATA=$2
            ;;
        '-i' )
            ID=$2
            ;;
        '--auth' )
            AUTH=1
            ;;
        '--session' )
            SESSION=$2
            ;;
        '-f' )
            FILE=$2
            ;;
        '--sign' )
            SIGN=1
            ;;
    esac
    shift
done

QUERY=""
if [ ! $AUTH = "" ]; then
  ID=""
  REQ_PATH="/2013-09-01/login"
  METHOD="GET"
  read -p "USER NAME:" USERNAME
  read -sp "PASSWORD:" PASSWORD
  echo ""
fi
DATE=`date '+%Y-%m-%dT%H:%M:%S%z'`
FQDN="mbaas.api.nifcloud.com"
str="SignatureMethod=HmacSHA256&SignatureVersion=2&X-NCMB-Application-Key=$APPLICATION_KEY&X-NCMB-Timestamp=$DATE"
if [ ! $ID = "" ]; then
  REQ_PATH="${REQ_PATH}/$ID"
fi
if [ ! $AUTH = "" ]; then
  str="$str&password=$PASSWORD&userName=$USERNAME"
  QUERY=" --data-urlencode 'userName=$USERNAME' --data-urlencode 'password=$PASSWORD'"
fi
if [ ! $FILE = "" ]; then
  FILENAME=`basename $FILE`
  REQ_PATH="/2013-09-01/files/$FILENAME"
fi
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
sigStr=${METHOD^^}"\n"$FQDN"\n"$REQ_PATH"\n"$str
sig=`echo -e -n ${sigStr} | openssl dgst -sha256 -binary -hmac ${CLIENT_KEY} | base64`

if [ ! $SIGN = "" ]; then
  echo "Timestamp is $DATE"
  echo "Signature is $sig"
  exit
fi
cmd="curl -s -S -X ${METHOD^^} -H \"X-NCMB-Application-Key: ${APPLICATION_KEY}\" \\
 -H \"X-NCMB-Timestamp: ${DATE}\" \\
 -H \"X-NCMB-Signature: ${sig}\""

if [ ! $FILE = "" ]; then
  cmd="$cmd -H \"Content-Type: multipart/form-data\""
  cmd="$cmd -F \"file=@$FILE\""
else
  cmd="$cmd -H \"Content-Type: application/json\""
fi

if [ ! $SESSION = "" ]; then
  cmd="${cmd} -H \"X-NCMB-Apps-Session-Token: ${SESSION}\" "
fi
 
if [ ${METHOD^^} = "GET" ]; then
  cmd="${cmd} -G ${QUERY}"
elif [ ${METHOD^^} = "POST" ]; then
  if [ $FILE = "" ]; then
    DATA="-d '$DATA'"
    cmd="${cmd} $DATA"
  fi
elif [ ${METHOD^^} = "PUT" ]; then
  DATA="-d '$DATA'"
  cmd="${cmd} $DATA"
elif [ ${METHOD^^} = "DELETE" ]; then
  :
fi

cmd="${cmd} https://mbaas.api.nifcloud.com${REQ_PATH}"

res=`sh -c "${cmd}"`
echo $res

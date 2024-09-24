# 2024 - Check Point Software - WAF LAB
# cp_api_trainer.sh 
# The following script was created to train the WAF API to learn the API Scheme of VAMPI application to demontrate
# the auto learning
# Write by Vince Mammoliti - vincem@checkpoint.com
# Version 0.4
#
#/usr/bin/bash

set -euo pipefail

declare vResponse='silentResponse'
function silentResponse () {
       	:
}

VFLAG=0
REPEAT=1
HOST="http://juiceshop.local:8500"
DOCKER_HOST="`hostname -I| awk ' {print $1}'`"

usage(){
>&2 cat << EOF
$0 is an API training tool to demonstrate the API learning capability of the Check Point Cloud Guard WAF
Written by Vince Mammoliti - vincem@checkpoint.com - 2024

Usage: $0 [OPTIONS...] [URL of VAMPI host - defaults to $HOST] 
  -v | --verbose             provides details of commands excuited against host  
  -r | --repeat              repeat the number of times to send api training requests. defaults to 1 
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


args=$(getopt -a -o vr:s --long help,verbose,repeat:,sql -- "$@")

if [[ $? -gt 0 ]]; then
  usage
fi

eval set -- ${args}
while :
do
  case $1 in
	-v | --verbose)   VFLAG=1 ; vResponse='echo' ; shift   ;;
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
   OUTPUT=$(curl -sS -H 'accept: application/json' -X 'GET' ${HOST}/)
   echo "1) GET /"; $vResponse $OUTPUT ; # If -v is enabled - prints out result of curl
   OUTPUT=$(curl -sS -H 'accept: application/json' -X 'GET' ${HOST}/books/v1)
   echo "2) GET /books/v1"; $vResponse $OUTPUT
   OUTPUT=$(curl -sS -H 'accept: application/json' -X 'GET' ${HOST}/users/v1)
   echo "3) GET /users/v1"; $vResponse $OUTPUT
   TOKEN=$(curl -sS -X POST   ${HOST}/users/v1/login   -H 'accept: application/json' \
	        -H 'Content-Type: application/json'  \
			-d '{ "password": "pass1", "username": "name1" }' \
				| jq -r '.auth_token')
   echo "4) POST /user/v1/login" ; $vResponse $OUTPUT 
   OUTPUT=$(curl -sS -H 'accept: application/json' -X 'GET' ${HOST}/users/v1/admin)
   echo "5) GET /users/v1/admin" ; $vResponse $OUTPUT
   OUTPUT=$(curl -sS -X 'POST'   ${HOST}/books/v1   -H 'accept: application/json' -H 'Content-Type: application/json'          -d '{
               "book_title": "cp-GCWAF-102",
               "secret": "cp-secret"
             }' -H "Authorization: Bearer $TOKEN "
	   )
   echo "6) POST /books/v1 - new book added"; $vResponse $OUTPUT  
   OUTPUT=$(curl -sS -X GET  ${HOST}/books/v1/cp-GCWAF-102   -H 'accept: application/json'  -H "Authorization: Bearer $TOKEN" )
   echo "7) books/v1/cp-GCWAF-102 - book details"; $vResponse $OUTPUT
#   OUTPUT=$(curl -sS -X GET  ${HOST}/books/v1/cp-GCWAF-102x   -H 'accept: application/json'  -H "Authorization: Bearer $TOKEN" )
#   echo "8) books/v1/cp-GCWAF-102x - bad book lookup "; $vResponse $OUTPUT
   OUTPUT=$(curl -sS -X 'POST'   ${HOST}/users/v1/register   -H 'accept: application/json' -H 'Content-Type: application/json'          -d '{
  			"email": "user@cpcgwaf.com",
    			"password": "pass1",
      			"username": "cgwaf2"
		      }'
	  )
   echo "9) POST /users/v1/register - add a new users "; $vResponse $OUTPUT
   OUTPUT=$(curl -sS -X PUT   ${HOST}/users/v1/cgwaf2/email   -H 'accept: */*' -H 'Content-Type: application/json' \
	 -d '{
          	"email": "use3@cp.com"
	     }' -H "Authorization: Bearer $TOKEN"
	  )
   echo "10) GET /users/v1/cpgwaf2/email - update email of user "; $vResponse $OUTPUT
   OUTPUT=$(curl -sS -X DELETE   ${HOST}/users/v1/cgwaf2  -H 'Content-Type: application/json' \
		               -H "Authorization: Bearer $TOKEN"
           )
   echo "11) DELETE /users/v1/cgwaf2 "; $vResponse $OUTPUT
   TOKEN=$(curl -sS -X POST   ${HOST}/users/v1/login   -H 'accept: application/json' \
	         -H 'Content-Type: application/json'  \
		         -d '{ "password": "pass1", "username": "admin" }' \
			         | jq -r '.auth_token')
   echo "12) POST /user/v1/login - login as admin user"
   OUTPUT=$(curl -sS -X DELETE   ${HOST}/users/v1/cgwaf2  -H 'Content-Type: application/json' \
                 -H "Authorization: Bearer $TOKEN"
                )
   echo "11) DELETE /users/v1/cgwaf2 - as an admin user"; $vResponse $OUTPUT


done
exit 0




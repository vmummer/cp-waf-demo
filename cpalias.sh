#/usr/bin/bash
<<<<<<< HEAD
#export TOKEN=cp-us-deb8a340-782f-433f-b069-677e90d8c36106b51d9a-a145-45a0-98c5-58177848eb28
=======
#export TOKEN=
>>>>>>> 4b9c8cdc33290bd867cbf2d31ce508a289ef897c
echo "Adding Check Point AppSec Lab Alias Commands.  Use cphelp for list of commands"
DOCKER_HOST="`hostname -I| awk ' {print $1}'`"
alias cptrbad='docker run -it --rm -v $(pwd)/data:/home/web-scraper/data --add-host juiceshop.local:$DOCKER_HOST -w /home/juice-shop-solver appsec-demo-test-host python main.py'
alias cptrgood='bash cp/cp_test_good.sh'
alias cpapitrainer='bash cp/cp_api_trainer.sh'
alias cpnano='docker exec -it cp-appsec-agent-container /usr/sbin/cpnano'
alias cpuninstall='docker exec -it cp-appsec-agent-container /usr/sbin/cpnano --uninstall'
alias cpagenttoken='docker exec -it cp-appsec-agent-container ./cp-nano-agent --token $TOKEN'
alias cptoken="bash cp/cp_token.sh"
alias cpnanol='docker exec -it cp-appsec-agent-container /usr/sbin/cpnano -s |grep -E "Policy|Last" ' 
alias cpwipe='docker-compose down &&  docker system prune -a'
alias cpcert='sh cp/cp_get_cert.sh'
alias cpfetch='git  config --global http.sslverify false && git clone https://github.com/vmummer/appsec-demo.git'
alias cphost='printf "Docker Host IP address used: $DOCKER_HOST \n"'
alias cphelp='printf "Check Point Lab Commands:\n
cpnano        Show detail status of AppSec Agent ( use as cpnano -s)
cpnanol       Show last update of the AppSec Agent
cpuninstall   Uninstall AppSec Agent
cpagenttoken  Install AppSec Agent and assign Token
cptoken       Display and update AppSec Agent Token Variable
cpcert        Fetch Cert required to load docker images
cptrbad       Juiceshop Bad  Traffic Generator
cptrgrood     Juiceshop Good Traffic Generator
cpwipe        Wipeout all Docker containers and required to pull new images
cpfetch       Fetches Clone from GitHub Lab Files appsec-demo.git
cphost        Shows the IP address of the Docker Host used
cphelp        Alias Command to help with Check Point Lab
<<<<<<< HEAD
cpapitrainer  Create API traffic to train WAF API gateway. Use -h for options
=======
cpapitrainer  Create API traffic to train WAF API gateway
>>>>>>> 4b9c8cdc33290bd867cbf2d31ce508a289ef897c
"'

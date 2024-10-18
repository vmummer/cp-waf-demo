#/usr/bin/bash
#export TOKEN=
# Updated Oct 2, 2024 - Added cpnanob
# Added Oct 11th, 2024 - Added cpnanov 
# Added Docker_HOST and HOST_IP and added more info on cpnanos
VERSION=2.5
echo "Adding Check Point WAF Lab Alias Commands, 2024 ver ${VERSION}.  Use cphelp for list of additional available commands"
DOCKER_HOST=$(docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}')
HOST_IP="`hostname -I| awk ' {print $1}'`"
alias cptrbad='docker run -it --rm -v $(pwd)/data:/home/web-scraper/data --add-host juiceshop.local:$DOCKER_HOST -w /home/juice-shop-solver cp-waf-demo-test-host python main.py'
alias cptrgood='bash cp/cp_test_good.sh'
alias cpapitrainer='bash cp/cp_api_trainer.sh'
alias cpnano='docker exec -it cp-waf /usr/sbin/cpnano'
alias cpuninstall='docker exec -it cp-waf /usr/sbin/cpnano --uninstall'
alias cpagenttoken='docker exec -it cp-waf ./cp-nano-agent.sh --token ${TOKEN}'
alias cptoken="bash cp/cp_token.sh"
alias cpnanol='docker exec -it cp-waf /usr/sbin/cpnano -s |grep -E "Policy|Last" ' 
alias cpnanos='echo "Check Point WAF Nano Agent Status" ; docker exec -it cp-waf /usr/sbin/cpnano -s |grep -E "^Version:|^Registration status|Reason:.{0,21}|CloudGuard|Policy version:|Manifest status:|Token is invalid" '
alias cpnanov='docker exec -it cp-waf /usr/sbin/cpnano -s |grep -E "^Version" '
alias cpwipe='docker-compose down &&  docker system prune -a'
alias cpcert='sh cp/cp_get_cert.sh'
alias cpfetch='git  config --global http.sslverify false && git clone https://github.com/vmummer/cp-waf-demo.git'
alias cphost='printf "IP Addresses Used: Docker: ${DOCKER_HOST} and Host IP: ${HOST_IP} \n"'
alias cphelp='printf "Check Point Lab Commands:\n
cpnano        Show detail status of WAF Agent ( use as cpnano -s)
cpnanos       Show the overall status of the WAF
cpnanol       Show last policy update of the WAF Agent
cpnanov       Show the current version of the WAF Agent
cpuninstall   Uninstall WAF Agent
cpagenttoken  Install WAF Agent and assign Token
cptoken       Display and update WAF Agent Token Variable
cpcert        Fetch Cert required to load docker images
cptrbad       Juiceshop Bad  Traffic Generator
cptrgrood     Juiceshop Good Traffic Generator
cpwipe        Wipeout all Docker containers and required to pull new images
cpfetch       Fetches Files and Templates to be used in this Lab from GitHub
cphost        Shows the IP address of the Docker Instance and Linux Host 
cphelp        Alias Command to help with Check Point Lab
cpapitrainer  Create API traffic to train WAF API gateway. Use -h for options
"'

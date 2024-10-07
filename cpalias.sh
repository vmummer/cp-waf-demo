#/usr/bin/bash
#export TOKEN=
# Updated Oct 2, 2024 - Added cpnanob
VERSION=2.2
echo "Adding Check Point WAF Lab Alias Commands, 2024 ver ${VERSION}.  Use cphelp for list of additional available commands"
DOCKER_HOST="`hostname -I| awk ' {print $1}'`"
alias cptrbad='docker run -it --rm -v $(pwd)/data:/home/web-scraper/data --add-host juiceshop.local:$DOCKER_HOST -w /home/juice-shop-solver cp-waf-demo-test-host python main.py'
alias cptrgood='bash cp/cp_test_good.sh'
alias cpapitrainer='bash cp/cp_api_trainer.sh'
alias cpnano='docker exec -it cp-waf /usr/sbin/cpnano'
alias cpuninstall='docker exec -it cp-waf /usr/sbin/cpnano --uninstall'
alias cpagenttoken='docker exec -it cp-waf ./cp-nano-agent.sh --token ${TOKEN}'
alias cptoken="bash cp/cp_token.sh"
alias cpnanol='docker exec -it cp-waf /usr/sbin/cpnano -s |grep -E "Policy|Last" ' 
alias cpnanos='docker exec -it cp-waf /usr/sbin/cpnano -s |grep -E "CloudGuard" '
alias cpwipe='docker-compose down &&  docker system prune -a'
alias cpcert='sh cp/cp_get_cert.sh'
alias cpfetch='git  config --global http.sslverify false && git clone https://github.com/vmummer/cp-waf-demo.git'
alias cphost='printf "Docker Host IP address used: $DOCKER_HOST \n"'
alias cphelp='printf "Check Point Lab Commands:\n
cpnano        Show detail status of WAF Agent ( use as cpnano -s)
cpnanos       Show the overall status of the WAF
cpnanol       Show last policy update of the WAF Agent
cpuninstall   Uninstall WAF Agent
cpagenttoken  Install WAF Agent and assign Token
cptoken       Display and update WAF Agent Token Variable
cpcert        Fetch Cert required to load docker images
cptrbad       Juiceshop Bad  Traffic Generator
cptrgrood     Juiceshop Good Traffic Generator
cpwipe        Wipeout all Docker containers and required to pull new images
cpfetch       Fetches Files and Templates to be used in this Lab from GitHub
cphost        Shows the IP address of the Docker Host used
cphelp        Alias Command to help with Check Point Lab
cpapitrainer  Create API traffic to train WAF API gateway. Use -h for options
"'

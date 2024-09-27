# Check Point CloudGuard WAF demo using Docker Compose
 
 This is an enhancement to Stuart Green's simple docker-compose environment for deploy a Check Point WAF embedded nano-agent demo. The enhancement allows for running on Windows WSL if required or any current standard linux distribution. It also includes an additional Client Host for traffic generations of good and bad web and API traffic.
  
The deployment includes four containers, Check Point WAF and Nginx, tester host with traffic generators, OWASP JuiceShop app and Vampi Api Test container.
 This was based off of Stuart Green's work

You will have two ways to access the Juice Store Web Site:  
* Port 80: Protected by AppSec  
* Port 3000: Direct to JuiceShop (unprotected)  

You can access the Vampi API Site:
* Port 5000: Direct to Vampi API (unprotected)  
* Port 8500: Direct to Vampi API (protected)  

## Instructions:
 
* Clone the repository
* From a machine with docker and docker-compose installed, run:  
```
source cpalias.sh          << Load Aliase commands
cptoken  cp-us-....token   << Token from Check Point Infinity Portal - WAF - puts token in .env so you don't have keep doing it>

cpcert                     << WSL does not provide CA certs - fetches the required to build the Docker Images. Only if you are using WSL
docker-compose down -v --remove-orphans
docker-compose build
docker-compose up
```
[DEMO HERE]

cphelp     - Will show alias command useful for this demo

cpnano -s			       # Check status of the WAF - needs to say "CloudGuard AppSec is up-to-date and ready"
                                       #  If not then reinstall the TOKEN - by  checking if you have saved the TOKEN 
				       #  cptoken will display the TOKEN if you have and then issuing cpagenttoken to reinstall the TOKEN
cptrgood http://juiceshop.local:80     # Use to generate good traffic 
                                         - This just does a simple crawl of the Juiceshop website

cptrbad http://juiceshop.local:80      # Use to generate questionable traffic on the Juiceshop website

cpapitrainer                           # Used to train the WAF API gateway and with -m to create malicious traffic 
docker-compose down
```
 


> Notes: 

Suggest you add juiceshop.local into your local systems /etc/hosts file. You can use the cphost to provide you with the local host IP address. 

ie: 

/home/lab/cp-waf-demo# cphost
Docker Host IP address used: 172.29.126.121


add into /etc/hosts

172.29.126.121 juiceshop.local 

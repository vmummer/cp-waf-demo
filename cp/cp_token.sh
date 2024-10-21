#/usr/bin/bash
# Oct 21 2024 - Updated check for .env :wq
if [[ $PWD =~ .*-demo/cp ]];then
        echo -e "cp_token is required to be run from <....>/cp-waf-demo root directory"
        exit 1
fi
if [ -z "$1" ]; then
        echo "Usage  cptoken         - Display curent TOKEN value" 
	echo "       cptoken <TOKEN> - Set TOKEN Variable - <Check Point CG WAF TOKEN copied from Infinity portal>"
        echo ""
	declare TOKEN
	touch .env
	source .env
        if [[ $TOKEN ]]; then
	       echo -e "TOKEN variable is set to: $TOKEN \n"
	       export TOKEN
	       exit 1
	       else
	          echo "TOKEN variable is NOT SET!  Please set before continuing with LAB"
	fi
        exit 1	
else
       touch .env
       sed -i '/TOKEN/I d' .env 
       echo "TOKEN='$1' " >> .env 

#        sed -i 's/TOKEN=.*/TOKEN='$1'/' .env
#       sed -i 's/TOKEN=.*/TOKEN='$1'/' cpalias.sh
#       removed the above line so we don't write the Token in the cpalias.sh  and make public just using .env 
        export TOKEN=$1
        echo -e "TOKEN varable is changed to: $TOKEN in .env file."
#	echo -e "Important reload the file via issuing the following command: \n source .env \n for variable to be set. "
fi

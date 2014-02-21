# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
	echo -en "\033c"
	#This one doesn't work for my SSH sessions, but leaving here in case it has
	#some other benefit; the above works, if you don't scroll up...
	[ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

GOODBYE='cYRNFR PBZR ONPX FBBA!'
if [ -n `which tr` ]; then
	echo $GOODBYE | tr a-zA-Z N-ZA-Mn-za-m
fi


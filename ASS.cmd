timer:
	timer clear
	timer start


   #  put get my %1      

##Main Loop


Ass:
        if $Appraisal.LearningRate = 34 then {
		ECHO *** Mind Locked after %t seconds! Gracefully exiting the script. ***
		timer stop
		goto assFinished
	} else {
                match assFinished 34/34
                match Ass Roundtime:
                                       pause 5
		put ass %1
                matchwait
                pause 


assFinished:
pause 1
        put spl
        pause
	put stow r
        pause
        put stow l
	exit
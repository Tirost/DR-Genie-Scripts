#Predict event

Study.sky:
	pause 1
	send study sky
	match cycle You feel a lingering sense of dissatisfaction
	match predict.do Roundtime
	matchwait

Cycle:
	pause
	pause 12
	goto study.sky

Predict.do:
	wait
	pause 1
	send predict event %1
	exit
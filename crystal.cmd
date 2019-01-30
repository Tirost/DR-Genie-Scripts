##Gazes into a sanowret crystal whenever Concentration is at 100% and Arcana is below 25/34

Mainloop:
	if ($concentration = 100 && $Arcana.LearningRate < 25) then
		{
		put gaze my crystal
		waitfor You feel quite enlightened, if a bit mentally tired.
		}
	pause 10
	goto mainloop
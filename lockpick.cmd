#
# LOCKPICK CARVING SCRIPT BY SHROOM OF TF 
#
### container1 is place to put MASTERS OR BELOW
var container1 backpack
### container2 is place to put GRANDMASTERS
var container2 skull
### DONT TOUCH ################################
var masters 0
var grandmasters 0
var keyblanks 0

TOP:
     echo **********************************************************************
     echo Remove armor, get all wounds healed and reduce burden before carving!
     echo **********************************************************************
     pause 2
     put smirk $charactername
     pause 0.5
     put get my carving knife
     pause 0.5
     if ("$righthandnoun" != "knife") then goto 

KHRI:
     put khri start safe sight focus hasten
     pause 2
     pause 0.5

CARVE:
GET.KEY:
     math keyblanks add 1
     pause 0.1
     matchre Carvelock1 You get a|already holding
     match Carvelock1 You need a free hand
     matchre GET.KEY2 I could not find|What were you
     put get my keyblank
     matchwait

GET.KEY2:
     pause 0.001
     matchre Carvelock1 You get a|already holding
     match Carvelock1 You need a free hand
     matchre Finish2 I could not find|What were you
     put get my keyblank from my key pocket
     matchwait

CARVELOCK1:
     pause 0.1
     pause 0.1
     matchre Carvelock2 a crude|a rough|a stout|a common|a slim|You need to be holding the keyblank
     matchre Carvelock2 a quality|a high quality|a superior|a professional|^I could not|find yourself holding a master's
     matchre End2 proudly glance down at a grandmaster's|initials|With the precision and skill shown only by true masters
     matchre End proudly glance down at a master's|It would be better|glance down at
     match Broken snaps like a twig.
     match Carvelock1 Wait
     put carve my keyblank with my car knife
     matchwait

CARVELOCK2:
     pause 0.1
     pause 0.1
     matchre Carvelock2 a crude|a rough|a stout|a common|a slim|You need to be holding the keyblank
     matchre Carvelock2 a quality|a high quality|a superior|a professional|^I could not|find yourself holding a master's
     matchre End2 grandmaster's|initials|With the precision and skill
     matchre End proudly glance down at a master's|It would be better
     match Broken snap
     match Carvelock2 Wait
     put carve my lock with my car knife
     matchwait

BROKEN:
     pause
     echo **** DOH! Broke one.. 
     goto Carve

END:
     math masters add 1
     pause 0.1
     pause 0.1
     put put lock in %container1
     goto Finish

END2:
     math grandmasters add 1
     pause 0.1
     pause 0.1
     put put lock in %container2
     goto Finish

FINISH:
     pause 0.1
     pause 0.1
     put exp
     waitfor Overall state of mind
     echo  
     echo *** %keyblanks lockpicks carved 
     echo *** %masters masters
     echo *** %grandmasters grandmasters
     echo
     goto Carve

NOKNIFE:
     pause 0.1
     echo *************************************
     echo ** NO CARVING KNIFE FOUND! ABORTING
     echo ************************************
     echo
     goto STAND
     
FINISH2:
     pause 0.1
     put exp
     waitfor Overall state of mind
     pause 0.1
     ECHO ************************************
     ECHO ************************************
     ECHO *** ALL OUT OF KEYBLANKS ***
     ECHO ************************************
     ECHO ************************************
     put put my knife in my %container1
     waitfor You put your

STAND:
     pause 0.3
     pause 0.2
     matchre STAND ^\.\.\.wait|^Sorry\,
     matchre STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre STAND ^The weight of all your possessions prevents you from standing\.
     matchre STAND ^You are overburdened and cannot manage to stand\.
     matchre STAND ^You are so unbalanced
     matchre FINISHED ^You stand (?:back )?up\.
     matchre FINISHED ^You stand up in the water
     matchre FINISHED ^You are already standing\.
     put stand
     matchwait

FINISHED:
     put clean $charactername
     put #echo >Log Lime **** Carved %keyblanks lockpicks 
     put #echo >Log Lime **** %masters Masters %grandmasters Grandmasters
     pause 0.5
     exit
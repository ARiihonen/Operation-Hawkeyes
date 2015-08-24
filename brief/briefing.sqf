//More info: https://community.bistudio.com/wiki/createDiaryRecord

//Add briefing files
player createDiarySubject ["Diary", "Diary"];

_missionExtra = if (playersNumber west > 9) then { "In addition, you are to destroy the militia's two weapon caches, located in Pustoshka end either Rogovo or Pogorevka."  } else { ""; };
_execOne = if (playersNumber west > 9) then { "towns"; } else { "target's location"; };
_execTwo = if (playersNumber west > 9) then { "taking out the weapon caches, and "; } else { ""; };

//these need to be added so that the one you want on the bottom is first
player createDiaryRecord ["Diary", ["Intel", LoadFile "brief\Intel.txt"]];
player createDiaryRecord ["Diary", ["Signal", LoadFile "brief\Signal.txt"]];
player createDiaryRecord ["Diary", ["Execution", format [LoadFile "brief\Execution.txt", _execOne, _execTwo] ]];
player createDiaryRecord ["Diary", ["Mission", format [LoadFile "brief\Mission.txt",_missionExtra] ]];
player createDiaryRecord ["Diary", ["Situation", LoadFile "brief\Situation.txt"]];

/*
You can set up briefings chancing automatically to adjust to mission parameters and randomised variables by using the format command and adding %X-parameter notations
to the briefing text files. For a detailed example, check out the mission files for No Time For Donuts.

player createDiaryRecord ["Diary", ["Name", format [LoadFile "brief\example.txt", var1, var2]]];
*/
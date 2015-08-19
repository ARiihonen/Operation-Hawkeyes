//More info: https://community.bistudio.com/wiki/createDiaryRecord

//Add briefing files
player createDiarySubject ["Diary", "Diary"];

//these need to be added so that the one you want on the bottom is first
player createDiaryRecord ["Diary", ["Intel", LoadFile "brief\Intel.txt"]];
player createDiaryRecord ["Diary", ["Mission", LoadFile "brief\Mission.txt"]];
player createDiaryRecord ["Diary", ["Situation", LoadFile "brief\Situation.txt"]];

/*
You can set up briefings chancing automatically to adjust to mission parameters and randomised variables by using the format command and adding %X-parameter notations
to the briefing text files. For a detailed example, check out the mission files for No Time For Donuts.

player createDiaryRecord ["Diary", ["Name", format [LoadFile "brief\example.txt", var1, var2]]];
*/
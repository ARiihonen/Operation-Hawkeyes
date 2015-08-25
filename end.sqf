_endState = _this select 0; 
_endTextStatus = _this select 1; 
_endTextTasks = _this select 2;
_endTextCasualties = _this select 3; 
_endTextPS = _this select 4;

sleep 2; 
1 cutText [_endTextStatus, "BLACK", 2];
sleep 5;  
2 cutText [_endTextTasks, "BLACK", 2];
sleep 5;  
3 cutText [_endTextCasualties, "BLACK", 2];
if (_endTextPS == "") then {
	3 cutFadeOut 300;
} else {
	sleep 10;  
	4 cutText [_endTextPS, "BLACK", 2];
	4 cutFadeOut 300;
};

sleep 15;

if (alive player) then {
	
	if (_endState == "partialwin" || _endState == "totalwin") then {
		[_endState, true, true] call BIS_fnc_endMission;
	} else {
		[_endState, false, true] call BIS_fnc_endMission;
	};

} else {
	["Dead", false, true] call BIS_fnc_endMission;
};
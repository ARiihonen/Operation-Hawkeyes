_endState = _this select 0; 
_endTextStatus = _this select 1; 
_endTextTasks = _this select 2;
_endTextCasualties = _this select 3; 
_endTextPS = _this select 4;

titleText [_endTextStatus, "BLACK OUT", 4];
titleText [_endTextTasks, "BLACK", 1];
titleText [_endTextCasualties, "BLACK", 1];
titleText [_endTextPS, "BLACK", 1];

if (alive player) then {
	
	if (_endState == "partialwin" || _endState == "totalwin") then {
		[_endState, true, true] call BIS_fnc_endMission;
	} else {
		[_endState, false, true] call BIS_fnc_endMission;
	};

} else {
	["Dead", false, true] call BIS_fnc_endMission;
};
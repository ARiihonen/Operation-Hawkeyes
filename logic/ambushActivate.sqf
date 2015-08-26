_town = _this;

_marker1 = format ["%1_ambush_boom1", _town];
_marker2 = format ["%1_ambush_boom2", _town];
_marker3 = format ["%1_ambush_boom3", _town];
_marker4 = format ["%1_ambush_boom4", _town];

{
	_bomb = "R_80mm_HE" createVehicle (markerPos _x);
	sleep 1;
} forEach [_marker1, _marker2, _marker3, _marker4];

ambushActivated = true;

sleep 10;

[[[(leader convoyGroup), "RadioAmbushStart"],"logic\radioMessage.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
sleep 5;
for "_i" from 0 to 2 do {
	[[[(leader convoyGroup), (format ["RadioAmbush%1_%2", _town, _i])],"logic\radioMessage.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
	sleep 3;
};
[[[(leader convoyGroup), "RadioAmbushStatic"],"logic\radioMessage.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
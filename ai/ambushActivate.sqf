_town = _this;

_marker1 = format ["%1_ambush_boom1", _town];
_marker2 = format ["%1_ambush_boom2", _town];
_marker3 = format ["%1_ambush_boom3", _town];
_marker4 = format ["%1_ambush_boom4", _town];

{
	_bomb = "Bo_Mk82" createVehicle (markerPos _x);
	sleep 1;
} forEach [_marker1, _marker2, _marker3, _marker4];
_town = _this;

call compile format ["status%1 = 'alert';", _town];

_groupedCheck = call compile format ["grouped%1", _town];

if (!_groupedCheck) then {
	_town call compile preprocessFile "ai\group.sqf";
};

_groups = call compile format ["actionGroups%1", _town];

{
	_x setVariable ["MGP_missionCanceled", true, false];
	
	while {(count (waypoints _x)) > 0} do {
		deleteWaypoint ((waypoints _x) select 0);
	};
	_x setBehaviour "AWARE";
	_x setCombatMode "RED";
	_x setSpeedMode "FULL";
	_x setFormation "WEDGE";
	
	_marker = format ["%1_defense_%2", _town, _forEachIndex];
	
	_wp = _x addWaypoint [markerPos _marker, 0];
	_wp setWaypointType "MOVE";
	_x setCurrentWaypoint _wp;
	
	_wp = _x addWaypoint [markerPos _marker, 0];
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointSpeed "NORMAL";
} forEach _groups;

if ((_town isEqualTo "A" && targetLocation == 0) || (_town isEqualTo "B" && targetLocation == 1)) then {
	groupedProtectionGroup setVariable ["MGP_missionCanceled", true, false];
	
	_wp = groupedProtectionGroup addWaypoint [getPos tango, 50];
	_wp setWaypointType "SAD";
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "RED";
	
	groupedProtectionGroup setCurrentWaypoint _wp;
};
_town = _this select 0;
_groups = _this select 1;

call compile format ["status%1 = 'help';", _town];

_otherTown = if (_town == "A") then { "B"; } else { "A"; };
_carMarker = format ["%1_vehicles", _town];

_patrolSpots = [];
for "_i" from 0 to 3 do {
	_markerName = format ["%1_alert_%2", _otherTown, _i];
	_patrolSpots set [count _patrolSpots, _markerName];
};

{
	_group = _x;
	
	_group setBehaviour "AWARE";
	_group setCombatMode "RED";
	_group setSpeedMode "FULL";
	_group setFormation "COLUMN";
	
	_wp = _group addWaypoint [markerPos _carMarker, 0];
	_wp setWaypointType "GETIN";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_inVehicles', true, false];
		(group this) setVariable ['MGP_outOfTown', false, false];
	"];
	_wp setWaypointName "Getin";
	
	_number = ["1", "2"] call BIS_fnc_selectRandom;
	_dismountMarker = if (_town == "B") then { "b_help_dismount"; } else { format ["a_help_dismount%1", _number]; };
	
	_wp = _group addWaypoint [markerPos _dismountMarker, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "COLUMN";
	_wp setWaypointName "Dismount spot";
	
	_wp = _group addWaypoint [markerPos _dismountMarker, 0];
	_wp setWaypointType "GETOUT";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointStatements ["true", "
		{ unassignVehicle _group; } forEach thisList; 
		(group this) setVariable ['MGP_inVehicles', false, false]; 
		(group this) setVariable ['MGP_outOfTown', true, false];"
	];
	_wp setWaypointName "Getout";
	
	_temp = _patrolSpots;
	_teamPatrolSpots = [];
	while {count _temp > 0} do {
		_spot = _temp select floor random count _temp;
		_teamPatrolSpots set [count _teamPatrolSpots, _spot];
		_temp = _temp - [_spot];
	};
	
	{
		_wp = _group addWaypoint [markerPos _x, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointSpeed "NORMAL";
		_wp setWaypointFormation "WEDGE";
		_wp setWaypointName format ["Patrol%1", _forEachIndex];
	} forEach _teamPatrolSpots;
	
	_wp = _group addWaypoint [markerPos _dismountMarker, 0];
	_wp setWaypointStatements ["true", "
		(group this) execVM 'ai\vehicleAssign.sqf';
	"];
	_wp setWaypointName "Back to cars";
	
	_wp = _group addWaypoint [markerPos _dismountMarker, 0];
	_wp setWaypointType "GETIN";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_inVehicles', true, false];
		(group this) setVariable ['MGP_outOfTown', false, false];
	"];
	_wp setWaypointName "Getin";
	
	_wp = _group addWaypoint [markerPos _carMarker, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "COLUMN";
	_wp setWaypointName "Back home";
	
	_wp = _group addWaypoint [markerPos _carMarker, 0];
	_wp setWaypointType "GETOUT";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "WEDGE";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_helpDone', true, false]; 
		{ unassignVehicle _group; } forEach thisList; 
		(group this) setVariable ['MGP_inVehicles', false, false];
	"];
	_wp setWaypointName "Getout";
	
	_wp = _group addWaypoint [markerPos _carMarker, 0];
	_wp setWaypointType "DISMISSED";
	_wp setWaypointName "Dismiss";
} forEach _groups;
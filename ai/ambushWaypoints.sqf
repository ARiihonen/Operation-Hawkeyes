_town = _this select 0;
_groups = _this select 1;

_vehicles = format ["%1_vehicles", _town];

_ambushWaypoints = [];
{
	_x setBehaviour "AWARE";
	_x setCombatMode "RED";
	_x setSpeedMode "FULL";
	_x setFormation "COLUMN";
	
	_wp = _x addWaypoint [markerPos _vehicles, 0];
	_wp setWaypointType "GETIN";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_inVehicles', true, false];
		(group this) setVariable ['MGP_outOfTown', false, false];
	"];
	_wp setWaypointName "Getin";
	
	_cutoffWp = format ["%1_ambush_cutoff", _town];
	_wp = _x addWaypoint [markerPos _cutoffWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_ambushStarted', true, false];
	"];
	_wp setWaypointName "Cutoff";
	
	_dismountWp = format ["%1_ambush_dismount_%2", _town, _forEachIndex];
	_wp = _x addWaypoint [markerPos _dismountWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "COLUMN";
	_wp setWaypointName "Dismount spot";
	
	_wp = _x addWaypoint [markerPos _dismountWp, 0];
	_wp setWaypointType "GETOUT";
	_wp setWaypointStatements ["true", "
		{ unassignVehicle _x; } forEach thisList; 
		(group this) setVariable ['MGP_inVehicles', false, false]; 
		(group this) setVariable ['MGP_outOfTown', true, false];
	"];
	_wp setWaypointName "Getout";

	_prepWp = format ["%1_ambush_prep_%2", _town, _forEachIndex];
	_wp = _x addWaypoint [markerPos _prepWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointFormation "WEDGE";
	_wp setWaypointStatements ["true", 
		format ["(group this) setFormDir ([this, markerPos %1] call BIS_fnc_dirTo);", _ambushWp]
	];
	_wp setWaypointName "Prep";
	
	_ambushWp = format ["%1_ambush_hide_%2", _town, _forEachIndex];
	_wp = _x addWaypoint [markerPos _ambushWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointBehaviour "STEALTH";
	_wp setWaypointCombatMode "GREEN";
	_wp setWaypointFormation "LINE";
	_ambushWaypoints set [count _ambushWaypoints, _wp];
	_wp setWaypointName "Hide";

	_assaultWp = format ["%1_ambush_assault_%2", _town, _forEachIndex];
	_wp = _x addWaypoint [markerPos _assaultWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointFormation "WEDGE";
	_wp setWaypointStatements ["true", "
		(group this) execVM 'ai\vehicleAssign.sqf'; 
	"];
	_wp setWaypointName "Assault";
	
	_wp = _x addWaypoint [markerPos _dismountWp, 0];
	_wp setWaypointSpeed "NORMAL"; 
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointCombatMode "GREEN";
	_wp setWaypointName "Back to vehicles";
	
	_wp = _x addWaypoint [markerPos _dismountWp, 0];
	_wp setWaypointType "GETIN";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_inVehicles', true, false];
		(group this) setVariable ['MGP_outOfTown', false, false];
	"];
	_wp setWaypointName "Getin";
	
	_wp = _x addWaypoint [markerPos _cutoffWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointFormation "COLUMN";
	_wp setWaypointStatements ["true", format ["status%1 = 'neutral';", _town]];
	_wp setWaypointName "Back cutoff";

	_wp = _x addWaypoint [markerPos _vehicles, 0];
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointName "Back home";

	_wp = _x addWaypoint [markerPos _vehicles, 0];
	_wp setWaypointType "GETOUT";
	_wp setWaypointFormation "WEDGE";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_ambushDone', true, false]; 
		{ unassignVehicle _x; } forEach thisList; 
		(group this) setVariable ['MGP_inVehicles', false, false]; 
	"];
	_wp setWaypointName "Getout";
	
	_wp = _x addWaypoint [markerPos _vehicles, 0];
	_wp setWaypointType "DISMISSED";
	_wp setWaypointName "Dismiss";
	
	diag_log "";
	diag_log format ["Assigned ambush waypoints for %1", _x];
	_waypointsAfterAssign = [];
	{
		_waypointsAfterAssign set [count _waypointsAfterAssign, waypointName _x];
	} forEach (waypoints _x);
	diag_log format ["Waypoints after assign: %1", _waypointsAfterAssign];
	diag_log format ["Current waypoint: %1", waypointName [_x, currentWaypoint _x]];
	diag_log "";
} forEach _groups;
call compile format ["ambushTrigger%1 synchronizeTrigger _ambushWaypoints;", _town];

_cutoffCheck = [_groups, _town] spawn {
	_groups = _this select 0;
	_town = _this select 1;
	
	_allGone = false;
	while {!_allGone} do {
		sleep 1;
		_allGone = true;
		{
			if (!(_x getVariable ["MGP_ambushStarted", false])) then {
				_allGone = false;
			};
		} forEach _groups;
		
		if (_allGone) then {
			call compile format ["status%1 = 'ambush';", _town];
		};
	};
};
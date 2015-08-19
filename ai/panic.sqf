_town = if (_this == "A") then { "B"; } else { "A"; };

_carMarker = format ["%1_vehicles", _town];

_groupedCheck = call compile format ["grouped%1", _town];
if (!_groupedCheck) then {
	_town call compile preprocessFile "ai\group.sqf";
};

_groups = call compile format ["actionGroups%1", _town];
{
	_carNumber = _forEachIndex;
	{
		_index = _forEachIndex;
		if (_index < 4) then {
			switch _index do {
				case 0: {
					call compile format ["_x assignAsDriver %1_veh_%2_1;", _town, _carNumber];
				};
				
				case 1: {
					call compile format ["_x assignAsGunner %1_veh_%2_1;", _town, _carNumber];
				};
				
				case 2: {
					call compile format ["_x assignAsCargo %1_veh_%2_1;", _town, _carNumber];
				};
				
				case 3: {
					call compile format ["_x assignAsDriver %1_veh_%2_2;", _town, _carNumber];
				};
			};
		} else {
			call compile format ["_x assignAsCargo %1_veh_%2_2;", _town, _carNumber];
		};
	} forEach units _x;
	
} forEach _groups;

{
	while {(count (waypoints _x)) > 0} do {
		deleteWaypoint ((waypoints _x) select 0);
	};
	_x setBehaviour "AWARE";
	_x setCombatMode "RED";
	_x setSpeedMode "NORMAL";
	_x setFormation "WEDGE";
	
	_wp = _x addWaypoint [markerPos _carMarker, 0];
	_wp setWaypointType "GETIN";
	_x setCurrentWaypoint _wp;
} forEach _groups;

if ((_town isEqualTo "A" && targetLocation == 0) || (_town isEqualTo "B" && targetLocation == 1)) then {
	
	tango assignAsDriver targetCarOne;
	
	{
		_index = _forEachIndex;
		
		if (_index == 0) then {
			_x assignAsDriver targetCarTwo;
		} else {
			if (_index % 2 == 0) then {
				_x assignAsCargo targetCarOne;
			} else {
				_x assignAsCargo targetCarTwo;
			};
		};
	} foreach (units groupedProtectionGroup - [tango]);
	
	while {(count (waypoints groupedProtectionGroup)) > 0} do {
		deleteWaypoint ((waypoints groupedProtectionGroup) select 0);
	};
	
	groupedProtectionGroup setBehaviour "AWARE";
	groupedProtectionGroup setCombatMode "RED";
	groupedProtectionGroup setSpeedMode "NORMAL";
	groupedProtectionGroup setFormation "WEDGE";
	
	_wp = groupedProtectionGroup addWaypoint [getPos targetCarOne, 0];
	_wp setWaypointType "GETIN";
	groupedProtectionGroup setCurrentWaypoint _wp;
	
	_groups = _groups + [groupedProtectionGroup];
};

{
	_x setVariable ["MGP_helpReady", false, false];
	_x setVariable ["MGP_missionCanceled", true, false];
} forEach _groups;

{
	_number = ["1", "2"] call BIS_fnc_selectRandom;
	
	_dismountMarker = if (_town == "B") then { "b_help_dismount"; } else { format ["a_help_dismount%1", _number]; };
	_wp = _x addWaypoint [markerPos _dismountMarker, 0];
	_wp setWaypointType "GETOUT";
	_wp setWaypointSpeed "LIMITED";
	
	_defenseMarker = if (_town == "B") then { "b_help_sad"; } else { format ["a_help_sad%1", _number]; };
	_wp = _x addWaypoint [markerPos _defenseMarker, 0];
	_wp setWaypointType "SAD";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointSpeed "NORMAL";
	
	_wp = _x addWaypoint [markerPos _dismountMarker, 0];
	_wp setWaypointType "GETIN";
	
	_wp = _x addWaypoint [markerPos _carMarker, 0];
	_wp setWaypointType "GETOUT";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointStatements ["true", "(group this) setVariable ['MGP_helpReady', true, false];"];
} forEach _groups;

_unGroupCheck = [_groups, _town] spawn {
	_groups = _this select 0;
	_town = _this select 1;
	
	_allDone = false;
	while {!_allDone} do {
		sleep 30;
		_allDone = true;
		{
			_status = _x getVariable "MGP_helpReady";
			if (!_status) then {
				_allDone = false;
			}:
		} forEach _groups;
		
		if (_allDone) then {
			_town execVM "ai\unGroup.sqf";
		};
	};
};
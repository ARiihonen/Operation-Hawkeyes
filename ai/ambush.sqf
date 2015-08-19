_town = _this;

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

_vehicles = format ["%1_vehicles", _town];
{
	while {(count (waypoints _x)) > 0} do {
		deleteWaypoint ((waypoints _x) select 0);
	};
	_wp = _x addWaypoint [markerPos _vehicles, 0];
	_wp setWaypointType "GETIN";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "YELLOW";
	_x setCurrentWaypoint _wp;
} forEach _groups;

if ((_town isEqualTo "A" && targetLocation == 0) || (_town isEqualTo "B" && targetLocation == 1)) then {
	{
		_index = _forEachIndex;
		
		if (_index == 0 || _index == 1) then {
			if (_index == 0) then {
				_x assignAsDriver targetCarOne;
			} else {
				_x assignAsDriver targetCarTwo;
			};
		} else {
			if (_index % 2 == 0) then {
				_x assignAsCargo targetCarOne;
			} else {
				_x assignAsCargo targetCarTwo;
			};
		};
	} foreach (units groupedProtectionGroup);
	
	while {(count (waypoints groupedProtectionGroup)) > 0} do {
		deleteWaypoint ((waypoints groupedProtectionGroup) select 0);
	};
	
	_wp = groupedProtectionGroup addWaypoint [getPos targetCarOne, 0];
	_wp setWaypointType "GETIN";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "YELLOW";
	groupedProtectionGroup setCurrentWaypoint _wp;

	_groups = _groups + [groupedProtectionGroup];
};

{
	_x setVariable ["MGP_missionReady", false, false];
} forEach _groups;

_ambushWaypoints = [];
{
	_cutoffWp = format ["%1_ambush_cutoff", _town];
	_wp = _x addWaypoint [markerPos _cutoffWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointStatements ["true", "(group this) setVariable ['MGP_missionStarted', true, false];"];

	_dismountWp = format ["%1_ambush_dismount_%2", _town, _forEachIndex];
	_wp = _x addWaypoint [markerPos _dismountWp, 0];
	_wp setWaypointType "MOVE";
	
	_wp = _x addWaypoint [markerPos _dismountWp, 0];
	_wp setWaypointType "GETOUT";

	_ambushWp = format ["%1_ambush_hide_%2", _town, _forEachIndex];
	_wp = _x addWaypoint [markerPos _ambushWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointCombatMode "YELLOW";
	
	_wp = _x addWaypoint [markerPos _ambushWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointBehaviour "STEALTH";
	_wp setWaypointCombatMode "GREEN";
	_ambushWaypoints set [count _ambushWaypoints, _wp];

	_assaultWp = format ["%1_ambush_assault_%2", _town, _forEachIndex];
	_wp = _x addWaypoint [markerPos _assaultWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointCombatMode "YELLOW";

	_wp = _x addWaypoint [markerPos _dismountWp, 0];
	_wp setWaypointType "GETIN";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointBehaviour "AWARE";

	_wp = _x addWaypoint [markerPos _cutoffWp, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointStatements ["true", format ["status%1 = 'neutral';", _town]];

	_wp = _x addWaypoint [markerPos _vehicles, 0];

	_wp = _x addWaypoint [markerPos _vehicles, 0];
	_wp setWaypointType "GETOUT";
	_wp setWaypointStatements ["true", "(group this) setVariable ['MGP_missionReady', true, false];"];
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
			if (!(_x getVariable ["MGP_missionStarted", false])) then {
				_allGone = false;
			};
		} forEach _groups;
		
		if (_allGone) then {
			call compile format ["status%1 = 'ambush';", _town];
		};
	};
};

_unGroupCheck = [_groups, _town] spawn {
	_groups = _this select 0;
	_town = _this select 1;
	
	_allDone = false;
	_cancel = false;
	while {!_allDone && !_cancel} do {
		sleep 1;
		_cancel = false;
		{
			if (_x getVariable ["MGP_missionCanceled", false]) then {
				_cancel = true;
			};
		} forEach _groups;
		
		if (!_cancel) then {
			_allDone = true;
			{
				_status = _x getVariable "MGP_missionReady";
				if (!_status) then {
					_allDone = false;
				};
			} forEach _groups;
			
			if (_allDone) then {
				_town execVM "ai\unGroup.sqf";
			};
		};
	};
};
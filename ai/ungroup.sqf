_town = _this;

_originalGroups = call compile format ["originalGroups%1", _town];

{
	_grp = createGroup east;
	(_x select 1) joinSilent _grp;
	{
		unassignVehicle _x;
	} forEach (_x select 1);
	
	while {(count (waypoints _grp)) > 0} do {
		deleteWaypoint ((waypoints _grp) select 0);
	};
	_grp copyWaypoints (_x select 0);
} forEach _originalGroups;

//original protection group spots
if ((_town isEqualTo "A" && targetLocation == 0) || (_town isEqualTo "B" && targetLocation == 1)) then {

	_homeMarker = format ["%1_target_home_%2", _town, target];
	
	{
		unassignVehicle _x;
	} forEach (units groupedProtectionGroup);
	_targetGroup = createGroup east;
	[tango, protectionManOne, protectionManTwo] joinSilent _targetGroup;
	while {(count (waypoints _targetGroup)) > 0} do {
		deleteWaypoint ((waypoints _targetGroup) select 0);
	};
	_wp = _targetGroup addWaypoint [markerPos _homeMarker, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointBehaviour "SAFE";
	_targetGroup setCurrentWaypoint _wp;
	
	_patrolGroupOne = createGroup east;
	(originalProtectionGroup select 3 select 1) joinSilent _patrolGroupOne;
	while {(count (waypoints _patrolGroupOne)) > 0} do {
		deleteWaypoint ((waypoints _patrolGroupOne) select 0);
	};
	_patrolGroupOne copyWaypoints (originalProtectionGroup select 3 select 0);
	
	_patroLGroupTwo = createGroup east;
	(originalProtectionGroup select 4 select 1) joinSilent _patrolGroupTwo;
	while {(count (waypoints _patrolGroupTwo)) > 0} do {
		deleteWaypoint ((waypoints _patrolGroupTwo) select 0);
	};
	_patrolGroupTwo copyWaypoints (originalProtectionGroup select 4 select 0);
};

call compile format ["grouped%1 = false;", _town];
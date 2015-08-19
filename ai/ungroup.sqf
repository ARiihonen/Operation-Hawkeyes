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
	{
		unassignVehicle _x;
	} forEach (units groupedProtectionGroup);
	_targetGroup = createGroup east;
	[tango] joinSilent _targetGroup;
	while {(count (waypoints _targetGroup)) > 0} do {
		deleteWaypoint ((waypoints _targetGroup) select 0);
	};
	_wp = _targetGroup addWaypoint [originalProtectionGroup select 0, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointBehaviour "SAFE";
	_targetGroup setCurrentWaypoint _wp;
	
	_dudeGroupOne = createGroup east;
	[protectionManOne] joinSilent _dudeGroupOne;
	while {(count (waypoints _dudeGroupOne)) > 0} do {
		deleteWaypoint ((waypoints _dudeGroupOne) select 0);
	};
	_wp = _dudeGroupOne addWaypoint [originalProtectionGroup select 1, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointBehaviour "SAFE";
	_dudeGroupOne setCurrentWaypoint _wp;
	
	_dudeGroupTwo = createGroup east;
	[protectionManTwo] joinSilent _dudeGroupTwo;
	while {(count (waypoints _dudeGroupTwo)) > 0} do {
		deleteWaypoint ((waypoints _dudeGroupTwo) select 0);
	};
	_wp = _dudeGroupTwo addWaypoint [originalProtectionGroup select 2, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "RED";
	_wp setWaypointBehaviour "SAFE";
	_dudeGroupTwo setCurrentWaypoint _wp;
	
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
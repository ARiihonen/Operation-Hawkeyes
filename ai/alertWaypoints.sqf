_town = _this select 0;
_groups = _this select 1;

call compile format ["status%1 = 'alert';", _town];

_defenseSpots = [];
for "_i" from 0 to 3 do {
	_markerName = format ["%1_alert_%2", _town, _i];
	_defenseSpots set [count _defenseSpots, _markerName];
};

{
	_group = _x;
	_defenseSpot = (_defenseSpots select _forEachIndex);
	
	_patrolSpotOrder = _defenseSpots;
	if (_forEachIndex  % 2 != 0) then {
		_temp = [];
		_i = (count _defenseSpots) - 1;
		while {_i >= 0} do {
			_spot = _defenseSpots select _i;
			_temp set [count _temp, _spot];
			
			_i = _i - 1;
		};
		_patrolSpotOrder = _temp;
	};
	
	_beforeSpot = [];
	_afterSpot = [];
	_temp = "before";
	{
		if (_x == _defenseSpot) then {
			_temp = "after";
		} else {
			if (_temp == "before") then {
				_beforeSpot set [count _beforeSpot, _x];
			} else {
				_afterSpot set [count _afterSpot, _x];
			};
		};
	} forEach _patrolSpotOrder;
	
	_patrolSpots = [];
	{
		_patrolSpots set [count _patrolSpots, _x];
	} forEach _afterSpot;
	
	{
		_patrolSpots set [count _patrolSpots, _x];
	} forEach _beforeSpot;
	
	_group setBehaviour "AWARE";
	_group setCombatMode "RED";
	_group setSpeedMode "NORMAL";
	_group setFormation "WEDGE";
	
	if (_group getVariable ["MGP_inVehicles", false] || _group getVariable ["MGP_outOfTown", false]) then {
		
		if (_group getVariable ["MGP_outOfTown", false]) then {
			_vehOne = (_group getVariable "MGP_groupVehicles") select 0;
			_wp = _group addWaypoint [getPos _vehOne, 0];
			_wp setWaypointType "GETIN";
			_wp setWaypointStatements ["true", "
				(group this) setVariable ['MGP_inVehicles', true, false];
				(group this) setVariable ['MGP_outOfTown', false, false];
			"];
			_wp setWaypointName "Getin";
		};
		
		_wp = _group addWaypoint [markerPos _defenseSpot, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed "NORMAL";
		_wp setWaypointFormation "COLUMN";
		_wp setWaypointName "Back home";
		
		_wp = _group addWaypoint [markerPos _defenseSpot, 0];
		_wp setWaypointType "GETOUT";
		_wp setWaypointSpeed "NORMAL";
		_wp setWaypointFormation "WEDGE";
		_wp setWaypointStatements ["true", "
			{ unassignVehicle _x; } forEach thisList;
			(group this) setVariable ['MGP_inVehicles', false, false];
		"];
		_wp setWaypointName "Getout";
	} else {
		while {(count (waypoints _group)) > 0} do {
			deleteWaypoint ((waypoints _group) select 0);
		};
		_wp = _group addWaypoint [markerPos _defenseSpot, 0];
		_wp setWaypointType "MOVE";
		_group setCurrentWaypoint _wp;
		_wp setWaypointName "Go defend";
	};

	_wp = _group addWaypoint [markerPos _defenseSpot, 0];
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "RED";
	//_wp setWaypointTimeout [600, 600, 600];
	_wp setWaypointTimeout [30, 30, 30];
	_wp setWaypointName "Defend";
	
	{
		_wp = _group addWaypoint [markerPos _x, 0];
		_wp setWaypointName format (["Patrol%1", _forEachIndex]);
	} forEach _patrolSpots;
	
	_wp = _group addWaypoint [markerPos _defenseSpot, 0];
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointStatements ["true", "
		(group this) setVariable ['MGP_alertDone', true, false];"
	];
	_wp setWaypointName "Back to defend";
	
	_wp = _group addWaypoint [markerPos _defenseSpot, 0];
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointName "Defend";
	
	diag_log "";
	diag_log format ["Assigned alert waypoints for %1", _group];
	_waypointsAfterAssign = [];
	{
		_waypointsAfterAssign set [count _waypointsAfterAssign, waypointName _x];
	} forEach (waypoints _group);
	diag_log format ["Waypoints after assign: %1", _waypointsAfterAssign];
	diag_log format ["Current waypoint: %1", waypointName [_group, currentWaypoint _group]];
	diag_log "";
	
} forEach _groups;
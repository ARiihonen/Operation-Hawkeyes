//this bit is for all AI scripts you want to run at mission start. Maybe you want to spawn in dudes or something.
{
	if (typeOf _x == "O_soldier_M_F" && !(_x in (unitsA + unitsB)) ) then {
		_x forceSpeed 0;
	};
} forEach allUnits;

{
	if (!isPlayer _x) then {
		_x execVM "ai\gear.sqf";
	};
} forEach allUnits;

_unitsPerGroup = round(count unitsA/groupCountA);
arrayA = [];
for "_i" from 1 to groupCountA do {
	_group = [];
	
	if (_i < groupCountA) then {
		for "_i" from 0 to (_unitsPerGroup-1) do {
			_unit = unitsA select 0;
			_group set [count _group, _unit];
			unitsA = unitsA - [_unit];
		};
	} else {
		while {count unitsA > 0} do {
			_unit = unitsA select 0;
			_group set [count _group, _unit];
			unitsA = unitsA - [_unit];
		};
	};
	
	arrayA set [count arrayA, _group];
};

_unitsPerGroup = round(count unitsB/groupCountB);
arrayB = [];
for "_i" from 1 to groupCountB do {
	_group = [];
	
	if (_i < groupCountB) then {
		for "_i" from 0 to (_unitsPerGroup-1) do {
			_unit = unitsB select 0;
			_group set [count _group, _unit];
			unitsB = unitsB - [_unit];
		};
	} else {
		while {count unitsB >  0} do {
			_unit = unitsB select 0;
			_group set [count _group, _unit];
			unitsB = unitsB - [_unit];
		};
	};
	
	arrayB set [count arrayB, _group];
};

//add radios to the group leaders
{
	(_x select 0) addItem "itemRadio";
} forEach (arrayA + arrayB);

//add radios to the badass dudes
{
	_x addItem "itemRadio";
} forEach (protectionGroup + [tango]);

//ambush randomisation
if (ambushTown != "C") then {
	[ambushTown, "ambush"] execVM "ai\mission.sqf";
};

_targetLoop = [] spawn {
	waitUntil {dayTime > 6};
	_targetTown = if (targetLocation == 0) then { "A"; } else { "B"; };
	_homeMarker = format ["%1_target_home_%2", _targetTown, target];
	
	while {true} do {
		sleep (10 + random 590);
		_statusTown = call compile format ["status%1", _targetTown];
		if (_statusTown == 'neutral') then {
			_grp = createGroup east;
			[tango, protectionManOne, protectionManTwo] joinSilent _grp;
			
			_grp setBehaviour "SAFE";
			_grp setSpeedMode "LIMITED";
			
			for "_i" from 1 to (1 + floor random 5) do {
				_wp = _grp addWaypoint [markerPos _homeMarker, 100];
			};
			
			_wp = _grp addWaypoint [markerPos _homeMarker, 0];
		};
	};
};

_civilianLoop = [] spawn {
	while {true} do {
		_minWait = 2;
		_maxWait = 10;
		if (dayTime < 6) then {
			_minWait = -1*((dayTime - 6)*20);
			_maxWait = _minWait * 20;
		};
		_waitTime = (_minWait + (random (_maxWait - _minWait)));
		sleep _waitTime;
		
		_town = ["A", "B"] call BIS_fnc_selectRandom;
		_otherTown = if (_town == "A") then { "B"; } else { "A"; };;
		
		_wpCentral = "";
		_otherWpCentral = "";
		if (_town == "A") then {
			_wpCentral = a_civ_centre;
			_otherWpCentral = [b_civ_centre_1, b_civ_centre_2] call BIS_fnc_selectRandom;
		} else {
			_otherWpCentral = a_civ_centre;
			_wpCentral = [b_civ_centre_1, b_civ_centre_2] call BIS_fnc_selectRandom;
		};
		
		_temp = call compile format ["civilians%1", _town];
		_civPool = [];
		{
			if (_x getVariable ["available", true]) then {
				_civPool set [count _civPool, _x];
			};
		} forEach _temp;
		
		_temp = call compile format ["civilianCars%1", _town];
		_carPool = [];
		{
			if (_x getVariable ["available", true]) then {
				_carPool set [count _carPool, _x];
			};
		} forEach _temp;
		
		_civilian = if (count _civPool > 0) then { _civPool call BIS_fnc_selectRandom; } else { false; };
		if (typeName _civilian != "BOOL") then {
			(group _civilian) setSpeedMode "LIMITED";
			(group _civilian) setBehaviour "CARELESS";
			_civilian setVariable ["available", false, false];
		};
		
		if (typeName _civilian != "BOOL") then {
			_car = if (count _carPool > 0 && random 1 > 0.8) then { ([_carPool,[_civilian],{_input0 distance _x},"ASCEND"] call BIS_fnc_sortBy) select 0; } else { false; };
			if (typeName _car != "BOOL") then {
				_car setVariable ["available", false, false];
			};
			
			_startWaypoints = if (typeName _car != "BOOL") then { [getPos _civilian, getPos _car]; } else { [getPos _civilian]; };
			_waypointCentral = if (typeName _car != "BOOL") then { _otherWpCentral; } else { _wpCentral; };
			_waypointRadius = ((triggerArea _waypointCentral) select 0);
			
			if (typeName _car != "BOOL") then {
				_civilian assignAsDriver _car;
				_carWp = (group _civilian) addWaypoint [getPos _car, 0];
				_carWp setWaypointType "GETIN";

				_carWp = (group _civilian) addWaypoint [getPos _waypointCentral, _waypointRadius];
				_carWp setWaypointType "MOVE";
				_getoutWP = (group _civilian) addWaypoint [waypointPosition _carWp, 0];
				_getoutWP setWaypointType "GETOUT";
			};
			
			for "_i" from 1 to (1+(floor random 5)) do {
				_wp = (group _civilian) addWaypoint [getPos _waypointCentral, _waypointRadius];
				_wp setWaypointType "MOVE";
			};
			
			if (typeName _car != "BOOL") then {
				_getInWP = (group _civilian) addWaypoint [getPos _car, 0];
				_getInWP setWaypointType "GETIN";
				
				_carWp = (group _civilian) addWaypoint [_startWaypoints select 1, 0];
				_carWp setWaypointType "MOVE";
				
				_getOutWp = (group _civilian) addWaypoint [_startWaypoints select 1, 0];
				_getOutWp setWaypointType "GETOUT";
				_getOutWp setWaypointStatements ["true", "(vehicle this) setVariable ['available', true, false]; unassignVehicle this"];
			};
			
			_wp = (group _civilian) addWaypoint [_startWaypoints select 0, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointStatements ["true", "this setVariable ['available', true, false];"];
		};
	};
};
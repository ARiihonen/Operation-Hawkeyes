_town = _this select 0;
_mission = _this select 1;

_groupedCheck = call compile format ["grouped%1", _town];
if (!_groupedCheck) then {
	_town call compile preprocessFile "ai\group.sqf";
};

_groups = call compile format ["actionGroups%1", _town];
if ((_town isEqualTo "A" && targetLocation == 0) || (_town isEqualTo "B" && targetLocation == 1)) then {
	_groups set [count _groups, groupedProtectionGroup];
};

{
	while {(count (waypoints _x)) > 0} do {
		deleteWaypoint ((waypoints _x) select 0);
	};
	
	if (_mission != "alert" || _x getVariable ["MGP_outOfTown", false]) then {
		_x call compile preprocessFile "ai\vehicleAssign.sqf";
	};
} forEach _groups;

{
	_x setVariable [format ["MGP_%1Done", _mission], false, false];
	_x setVariable [format ["MGP_%1Canceled", _mission], false, false];
	
	if (_mission == "alert" || _mission == "help") then {
		_x setVariable ["MGP_ambushCanceled", true, false];
		
		if (_mission == "alert") then {
			_x setVariable ["MGP_helpCanceled", true, false];
		};
	};
} forEach _groups;

[_town, _groups] execVM (format ["ai\%1waypoints.sqf", _mission]);

_unGroupCheck = [_groups, _town, _mission] spawn {
	_groups = _this select 0;
	_town = _this select 1;
	_mission = _this select 2;
	
	_allDone = false;
	_cancel = false;

	while {!_allDone && !_cancel} do {
		sleep 1;
		
		{
			{
				if (!alive _x) then {
					[_x] joinSilent grpNull;
				};
			
			} forEach units _x;
		} forEach _groups;
		
		_cancel = false;
		{
			if (_x getVariable [format ["MGP_%1Canceled", _mission], false]) then {
				_cancel = true;
			};
		} forEach _groups;
		
		if (!_cancel) then {
			_allDone = true;
			{
				_status = _x getVariable [(format ["MGP_%1Done", _mission]), true];
				if (!_status) then {
					_allDone = false;
				};
			} forEach _groups;
			
			if (_allDone) then {
				call compile format ["status%1 = 'neutral';", _town];
				_town execVM "ai\unGroup.sqf";
			};
		};
	};
};
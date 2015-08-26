_seenUnits = _this;

{
	_unit = _x;
	
	if (!(_unit getVariable ["MGP_civilianAlerted", false])) then {
		{
			if ( (_unit knowsAbout _x) > 1) then {
				_unit setVariable ["available", false, false];
				_unit setVariable ["MGP_civilianAlerted", true, false];
				
				_closestCentral = ([[a_civ_centre, b_civ_centre_1, b_civ_centre_2],[_unit],{_input0 distance _x},"ASCEND"] call BIS_fnc_sortBy) select 0;
				_town = if (_closestCentral == a_civ_centre) then { "A"; } else { "B"; };
				
				while {(count (waypoints (group _unit))) > 0} do {
					deleteWaypoint ((waypoints (group _unit)) select 0);
				};
				
				_trg = createTrigger ["EmptyDetector", getPos _unit];
				_trg setTriggerArea [50, 50, 0, false];
				_trg setTriggerActivation ["ANY", "PRESENT", false];
				
				_wp = (group _unit) addWaypoint [getPos _closestCentral, 0];
				_wp setWaypointSpeed "FULL";
				for "_i" from 1 to 5 do {
					_wp = (group _unit) addWaypoint [getPos _closestCentral, 50];
					_wp setWaypointSpeed "FULL";
				};
				
				_trg = createTrigger ["EmptyDetector", getPos _unit];
				_trg setTriggerArea [50, 50, 0, false];
				_trg setTriggerActivation ["EAST", "PRESENT", false];
				_trg setTriggerStatements ["this", 
					format ["if (status%1 == 'neutral' || status%1 == 'help') then { ['%1', 'alert'] execVM 'ai\mission.sqf'; };", _town]
				, 
					""
				];
				
				_trg attachTo [_unit, [0,0,0]];
			};
		} forEach _seenUnits;
	};
} forEach (civiliansA + civiliansB);
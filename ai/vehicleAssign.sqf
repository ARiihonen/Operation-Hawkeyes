_group = _this;

if (!(_group getVariable ["MGP_inVehicles", false])) then {
	
	_vehOne = (_group getVariable "MGP_groupVehicles") select 0;
	_vehTwo = (_group getVariable "MGP_groupVehicles") select 1;
	
	if (canMove _vehOne || canMove _vehTwo) then {

		_getInVeh = if (canMove _vehOne) then { _vehOne; } else { _vehTwo; };
		
		_aliveMembers = [];
		{
			unassignVehicle _x;
			
			if (alive _x) then {
				_aliveMembers set [count _aliveMembers, _x];
			};
		} forEach (units _group);

		if (typeOf _vehOne == "C_Offroad_01_F") then {
			
			if (canMove _vehOne) then {
				if (tango in _aliveMembers) then {
					tango assignAsDriver _vehOne;
					_aliveMembers = _aliveMembers - [tango];
				} else {
					_oneDriver = _aliveMembers select 0;
					_oneDriver assignAsDriver _vehOne;
					_aliveMembers = _aliveMembers - [_oneDriver];
				};
			};
			
			{
				if (_forEachIndex == 0) then {
					if (canMove _vehTwo) then {
						_x assignAsDriver _vehTwo;
					};
				} else {
					if (_forEachIndex % 2 == 0) then {
						if (canMove _vehOne) then {
							_x assignAsCargo _vehOne;
						};
					} else {
						if (canMove _vehTwo) then {
							_x assignAsCargo _vehTwo;
						};
					};
				};
			} foreach _aliveMembers;
			
		} else {
			{
				if (_forEachIndex < 4) then {
					switch _forEachIndex do {
						case 0: {
							if (canMove _vehOne) then {
								_x assignAsDriver _vehOne;
							};
						};
						
						case 1: {
							if (canMove _vehOne) then {
								_x assignAsGunner _vehOne;
							};
						};
						
						case 2: {
							if (canMove _vehOne) then {
								_x assignAsCargo _vehOne;
							};
						};
						
						case 3: {
							if (canMove _vehTwo) then {
								_x assignAsDriver _vehTwo;
							};
						};
					};
				} else {
					if (canMove _vehTwo) then {
						_x assignAsCargo _vehTwo;
					};
				};
			} forEach _aliveMembers;
		};
	};
};
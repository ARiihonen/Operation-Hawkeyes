_town = _this;

_array = call compile format ["groups%1", _town];
_originalGroups = [];
{	
	_wpCache = createGroup east;
	_wpCache copyWaypoints _x;
	
	_cacheGroup = [];
	
	_cacheGroup set [0, _wpCache];
	_cacheGroup set [1, units _x];
	
	_originalGroups set [count _originalGroups, _cacheGroup];
} forEach _array;
call compile format ["originalGroups%1 = _originalGroups;", _town];

_array = call compile format ["array%1", _town];
_actionGroups = [];
{
	_grp = createGroup east;
	_x joinSilent _grp;
	_actionGroups set [count _actionGroups, _grp];
} forEach _array;

if ((_town isEqualTo "A" && targetLocation == 0) || (_town isEqualTo "B" && targetLocation == 1)) then {
	originalProtectionGroup = [[getPos tango], [getPos protectionManOne], [getPos protectionManTwo]];
	{
		_wpCache = createGroup east;
		_wpCache copyWaypoints _x;
		
		_dudes = units _x;
		_array = [_wpCache, _dudes];
		
		originalProtectionGroup set [count originalProtectionGroup, _array];
	} forEach [protectionPatrolOne, protectionPatrolTwo];
	
	_grp = createGroup east;
	(protectionGroup + [tango]) joinSilent _grp;
	groupedProtectionGroup = _grp;
};

call compile format ["grouped%1 = true;", _town];
call compile format ["actionGroups%1 = _actionGroups;", _town];
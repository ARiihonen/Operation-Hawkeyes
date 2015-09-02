//read the unit and the damager from the event handler
_unit = _this select 0;
_damager = _this select 1;

hint format ["%1 hit by %2", _unit, _damager];

//add the damager to the unit's "hitBy"-list, as the last item. If damager is already in the list, remove him from his earlier position first.
_hitList = _unit getVariable ["MGP_hitList", []];
if (_damager in _hitList) then {
	_hitList = _hitList - [_damager];
};
_hitList set [count _hitList, _damager];

//set the variable
_unit setVariable ["MGP_hitList", _hitList];

/*
if (side _unit == civilian) then {
	{
		if (_x select 0 == _unit) then {
			civiliansHit = civiliansHit - [_x];
		};
	} forEach civiliansHit;
	civiliansHit set [count civiliansHit, [_unit, _hitList]];
} else {
	tangoHit = _hitList;
};
*/
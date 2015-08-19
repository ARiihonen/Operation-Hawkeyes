/*
takes an array, picks a random selection of items from it, and returns the new one

Use: array = [array, minimumCount, maximumCount] call compile preprocessFile "logic\randomise.sqf";
*/

array = _this select 0;
_min = _this select 1;
_max = _this select 2;

_difference = _max - _min;
if (_difference < 0) then {
	_temp = _min;
	_min = _max;
	_max = _temp;
};

_rand = floor (random (_difference+1));
_amount = _min + _rand;

while {count array > _amount} do {
	_ind = array select floor random count array;
	array = array - [_ind];
};

array = array - [objNull];

array
/*
This script is defined as a pre-init function in description.ext, meaning it runs before objects initialise on the map.

I use it to set up a randomisation system for the enemies and other randomised objects. Each object to be randomised has a condition of existence set up in the editor, which
refers to variables randomised here. The end result lets me scale the amount of enemies by amount of players as well as randomising their positions from a pool of pre-chosen
potential locations. For an example, check out the mission files for No Time For Donuts
*/

if (isServer) then {

	statusA = "neutral";
	statusB = "neutral";
	
	groupedA = false;
	groupedB = false;
	
	targetLocation = floor random 2;
	target = floor random 4;
	
	cacheA = floor random 4;
	cacheB = floor random 4;
	
	ambushTown = "C";
	/*
	if (random 1 > 0.75) then {
		_village = ["A", "B"] call BIS_fnc_selectRandom;
		ambushTown = _village;
	};
	*/
	
	assault = [];
	if (random 1 < 0.25) then {
		for "_i" from 1 to 8 do {
			assault set [count assault, _i];
		};
		
		assault = [assault, 2, 2] call compile preprocessFile "logic\randomise.sqf";
	};
	
	_minMilitiaA = if (targetLocation == 0) then { 6; } else { 18; };
	_maxMilitiaA = if (targetLocation == 0) then { 18; } else { 27; };
	_potentialMilitiaA = [];
	for "_i" from 1 to 81 do {
		_potentialMilitiaA set [count _potentialMilitiaA, _i];
	};
	militiaA = [_potentialMilitiaA, _minMilitiaA, _maxMilitiaA] call compile preprocessFile "logic\randomise.sqf";
	
	groupCountA = 1;
	if (count militiaA > 7) then {
		if (count militiaA > 17) then {
			groupCountA = 3;
		} else {
			groupCountA = 2;
		};
	};
	
	_minMilitiaB = if (targetLocation == 1) then { 6; } else { 18; };
	_maxMilitiaB = if (targetLocation == 1) then { 18; } else { 27 };
	_potentialMilitiaB = [];
	for "_i" from 1 to 80 do {
		_potentialMilitiaB set [count _potentialMilitiaB, _i];
	};
	militiaB = [_potentialMilitiaB, _minMilitiaB, _maxMilitiaB] call compile preprocessFile "logic\randomise.sqf";
	
	groupCountB = 1;
	if (count militiaB > 7) then {
		if (count militiaB > 17) then {
			groupCountB = 3;
		} else {
			groupCountB = 2;
		};
	};
	
	_militiaAmount = (count militiaA) + (count militiaB);
	_minCivilians = 15;
	_maxCivilians = 70-_militiaAmount;
	_potentialCivilians = [];
	for "_i" from 1 to 63 do {
		_potentialCivilians set [count _potentialCivilians, _i];
	};
	civilians = [_potentialCivilians, _minCivilians, _maxCivilians] call compile preprocessFile "logic\randomise.sqf";
	
	unitsA = [];
	unitsB = [];
	
	groupsA = [];
	groupsB = [];
	originalGroupsA = [];
	originalGroupsB = [];
	
	protectionGroup = [];
	originalProtectionGroup = [];
	
	civiliansA = [];
	civiliansB = [];
	civilianCarsA = [];
	civilianCarsB = [];
};
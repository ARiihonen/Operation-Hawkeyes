_killed = _this select 0;
_killer = _this select 1;

if (side _killer == west || side _killer == resistance) then {
	civiliansKilled = civiliansKilled + 1;
	if (side _killer == west) then {
		civiliansKilledByPlayers = true;
	};
};
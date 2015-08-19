/*
This runs on the server machine after objects have initialised in the map. Anything the server needs to set up before the mission is started is set up here.
*/

//TFAR parameters you might want to change. The names should be self-explanatory.
#include "\task_force_radio\functions\common.sqf";

tf_no_auto_long_range_radio = true;
tf_give_personal_radio_to_regular_soldier = false;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

tf_west_radio_code = "_bluefor"; //every side with the same radio code can talk to each other on radio, if on the same channel
tf_defaultWestBackpack = "tf_rt1523g"; //backpack radio
tf_defaultWestPersonalRadio = "tf_anprc152"; //fancy short range radio
tf_defaultWestRiflemanRadio = "tf_rf_7800str"; //shit short range radio
tf_defaultWestAirborneRadio = "tf_anarc210"; //never used this one idk

_settingsSwWest = false call TFAR_fnc_generateSwSettings;
_settingsSwWest set [2, ["31.1","31.2","31.3","31.4","31.5"]];
tf_freq_west = _settingsSwWest;

_settingsLrWest = false call TFAR_fnc_generateLrSettings;
_settingsLrWest set [2, ["31","32","33","40","50","51"]];
tf_freq_west_lr = _settingsLrWest;

//set respawn tickets to 0
[missionNamespace, 1] call BIS_fnc_respawnTickets;
[missionNamespace, -1] call BIS_fnc_respawnTickets;

{
	if (typeOf _x == "O_OFFICER_F") then {
		tango = _x;
	};
} forEach allUnits;

_veh = targetCarOne;
[
	_veh,
	["red",1],
		"HideGlass2", 1,
	[
		"HideBackpacks", 0,
		"HideBumper1", 0,
		"HideConstruction", 0,
		"Proxy", 0,
		"Destruct", 0
	]
] call BIS_fnc_initVehicle,

//Task setting: ["TaskName", locality, ["Description", "Title", "Marker"], target, "STATE", priority, showNotification, true] call BIS_fnc_setTask;
if (playersNumber west > 9) then {
	["caches", true, ["Destroy the militia ammo caches from both towns", "Destroy Caches", ""], nil, "ASSIGNED", 1, false, true] call BIS_fnc_setTask;
};

["kill", true, ["Capture or kill the militia leader.", "Neutralise leader", ""], nil, "ASSIGNED", 2, false, true] call BIS_fnc_setTask;

/*
//Spawns a thread that will run a loop to keep an eye on mission progress and to end it when appropriate, checking which ending should be displayed.
_progress = [] spawn {
	
	//Init all variables you need in this loop
	_ending = false;
	_playersDead = false;

	//Starts a loop to check mission status every second, update tasks, and end mission when appropriate
	while {!_ending} do {
		
		sleep 1;
		
		//Mission ending condition check
		if ( _playersDead ) then {
			_ending = true;
			
			//Runs end.sqf on everyone. For varying mission end states, calculate the correct one here and send it as an argument for end.sqf
			[[[],"end.sqf"], "BIS_fnc_execVM", true, false] spawn BIS_fnc_MP;
		};
		
		//Sets _playersDead as true if nobody is still alive
		_playersDead = true;
		{
			if (alive _x) then {
				_playersDead = false;
			};
		} forEach playableUnits;
		
		_playersInBase = true;
		{
			if (!(alive _x || _x in baseTrigger)) then {
				_playersInBase = false;
			};
		} forEach playableUnits;

		//Updating tasks example: ["TaskName", "STATE", false] call BIS_fnc_taskSetState;
		//Custom task update notification: [ ["NotificationName", ["Message"]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
	};
};
*/
//client inits wait for serverInit to be true before starting, to make sure all variables the server sets up are set up before clients try to refer to them (which would cause errors)
serverInit = true;
publicVariable "serverInit";
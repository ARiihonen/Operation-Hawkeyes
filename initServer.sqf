/*
This runs on the server machine after objects have initialised in the map. Anything the server needs to set up before the mission is started is set up here.
*/

//set respawn tickets to 0
[missionNamespace, 1] call BIS_fnc_respawnTickets;
[missionNamespace, -1] call BIS_fnc_respawnTickets;

//set the existing target unit as variable tango for identification, add an event handler to verify who killed him
{
	if (typeOf _x == "O_OFFICER_F") then {
		tango = _x;
		publicVariable "tango";
	};
} forEach allUnits;

//set vehicle appearances for target's personal vehicles and the players' cars
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

_veh = targetCarTwo;
[
	_veh,
	["guerilla_01",1],
	[
		"HideBackpacks", 0,
		"HideBumper1", 0,
		"HideConstruction", 0,
		"Proxy", 0,
		"Destruct", 0
	]
] call BIS_fnc_initVehicle;

_veh = playerCarOne;
[
	_veh,
	["blue",1],
	[
		"HideGlass2", 1,
		"HideBumper2", 0,
		"HideConstruction", 0,
		"Proxy", 0,
		"Destruct", 0
	]
] call BIS_fnc_initVehicle;

_veh = playerCarTwo;
[
	_veh,
	["blue",1],
	[
		"HideGlass2", 1,
		"HideBumper2", 0,
		"HideConstruction", 0,
		"Proxy", 0,
		"Destruct", 0
	]
] call BIS_fnc_initVehicle;


//add gear to player vehicles, weapon caches, and the convoy
{
	_x execVM "player\vehicleGear.sqf";
} forEach [heko, playerCarOne, playerCarTwo];

{
	_x execVM "ai\stashGear.sqf";
	_x setMass 1000;
} forEach [stashA, stashB];

{
	_x execVM "ai\convoyGear.sqf";
} forEach [convoyOne, convoyTwo, convoyThree, convoyFour, convoyFive];

//Set tasks. If more than 9, players, also add a task to destroy the weapon caches
["tango", true, ["Capture or kill the militia leader.", "Neutralise leader", "marker_ao"], nil, "ASSIGNED", 1, false, true] call BIS_fnc_setTask;
_cacheTaskAssigned = false;
if (playersNumber west > 9) then {
	["caches", true, ["Destroy the militia ammo caches from both towns", "Destroy Caches", "marker_ao"], nil, "CREATED", 2, false, true] call BIS_fnc_setTask;
	_cacheTaskAssigned = true;
};
["return", true, ["Return to base after the mission is complete", "Extract", "respawn_west"], nil, "CREATED", 3, false, true] call BIS_fnc_setTask;
"tango" call BIS_fnc_taskSetCurrent;

//Spawns a thread that will run a loop to keep an eye on mission progress and to end it when appropriate, checking which ending should be displayed.
_progress = [_cacheTaskAssigned] spawn {
	
	//Init all variables you need in this loop
	_ending = false;
	_playersDead = false;
	
	//task variables
	_killTaskUpdated = false;
	_cacheTaskAssigned = _this select 0;
	_destroyTaskUpdated = false;
	
	//ending variables
	_thingDone = false;
	_playersInBase = false;
	_playersEscaped = false;
	
	//tracking dead civilians and hostiles
	_independentStart = 0;
	_opforStart = 0;
	{
		if (!isPlayer _x) then {
			switch (side _x) do {
				case resistance: { _independentStart = _independentStart + 1; };
				case east: { _opforStart = _opforStart + 1; };
			};
		};
	} forEach allUnits;
	
	//all civilians and the target need an event handler to check who last damaged them, in order to find out who killed them at the end of the mission
	{
		_x addEventHandler ["Hit", {_this execVM "logic\killedBy.sqf"}];
	} forEach (civiliansA + civiliansB + [tango]);

	//Starts a loop to check mission status every second, update tasks, and end mission when appropriate
	while {!_ending} do {
		
		sleep 1;
		
		//Mission ending condition check: if ending forced, players are dead, or players have entered the AO and returned to base or left it with the helo destroyed
		if ( forceEnding || _playersDead || (_thingDone && ( _playersInBase || _playersEscaped )) ) then {
			_ending = true;
			
			//check whether the target is captive: captive if target is in base or within 20 metres of an alive player (in case of playersEscaped)
			_tangoCaptured = false;
			if (tango in list trigger_base) then {
				_tangoCaptured = true;
			} else {
				{
					_dist = _x distance tango;
					if (alive _x && _dist < 20) then {
						_tangoCaptured = true;
					};
				} forEach playableUnits;
			};
			
			//check whether the target is dead and, if he is, who killed him:
			_tangoKilledBy = "";
			if (!alive tango || side tango == civilian) then {
				_damagers = tango getVariable "MGP_hitList";
				_lastDamager = _damagers select (count _damagers - 1);
				
				if (isPlayer _lastDamager) then {
					_tangoKilledBy = "PLAYER";
				} else {
					switch (side _lastDamager) do {
						case west: {
							_tangoKilledBy = "CONVOY";
						};
						
						case resistance: {
							_tangoKilledBy = "ASSAULT";
						};
						
						default {
							_tangoKilledBy = "ACCIDENT";
						};
					};
				};
			};

			//if kill has not been confirmed (and so the task has not been updated), update task to succeeded if tango is dead, captured, or a civilian (unconscious by ACE)
			if (!killConfirmed) then {
				if ( !alive tango || _tangoCaptured || side tango == civilian ) then {
					["tango", "SUCCEEDED", false] call BIS_fnc_taskSetState;
				} else {
					["tango", "FAILED", false] call BIS_fnc_taskSetState;
				};
			};
			
			//if the cache task was given, update task status as appropriate (succeeded if both destroyed, failed if not)
			if (_cacheTaskAssigned) then {
				if (!alive stashA && !alive stashB) then {
					["caches", "SUCCEEDED", false] call BIS_fnc_taskSetState;
				} else {
					["caches", "FAILED", false] call BIS_fnc_taskSetState;
				};
			};
			
			//update extraction task as appropriate: succeeded if playersInBase, canceled if playersEscaped, failed if neither
			if (_playersInBase || _playersEscaped) then {
				if (_playersInBase) then {
					["return", "SUCCEEDED", false] call BIS_fnc_taskSetState;
				} else {
					["return", "CANCELED", false] call BIS_fnc_taskSetState;
				};
			} else {
				["return", "FAILED", false] call BIS_fnc_taskSetState;
			};
			
			//Start figuring out the ending debriefing paragraphs
			
			/*
			First, the official evaluation: if target verifiably killed or captured, recognise as success, 
			if not BUT the target was killed by the raid, describe evaluation as "initial", otherwise "official"
			*/
			_recognitionState = if (_tangoKilledBy == "PLAYER" && !killConfirmed) then { "initially"; } else { "officially"; };
			_successState = if (killConfirmed || _tangoCaptured) then { "success."; } else { "failure."; };
			
			/*
			If the cache task was given, additionally describe the success/failure as complete or partial based on if all objectives were
			completed/failed or just some of them: primary task was a success AND both stashes destroyed: complete success, else: partial success;
			primary task failed AND both stashes undestroyed: complete failure, else: partial failure
			*/
			if (_cacheTaskAssigned) then {
				if (_successState == "success") then {
					if (!alive stashA && !alive stashB) then {
						_successState = format ["complete %1", _successState];
					} else {
						_successState = format ["partial %1", _successState];
					};
				} else {
					if (alive stashA && alive stashB) then {
						_successState = format ["complete %1", _successState];
					} else {
						_successState = format ["partial %1", _successState];
					};
				};
			};
			
			//syntax append
			_successState = format ["a %1", _successState];
			
			//format the first ending slide (evaluation):
			_endTextStatus = format ["Operation HIFK was %1 considered %2", _recognitionState, _successState];
			
			
			//Next slide: detailing which tasks were failed or completed.
			//first, explaining why the victory was "complete" or "partial" if the cache task was assigned:
			_tasksTotal = "";
			if (_cacheTaskAssigned) then {
				_tasksTotal = "None"; //pessimistically, the default is going to be that none of the tasks were done
				
				//if the target was killed or captured by the raid AND both caches were destroyed, change the text to:
				if ( (_tangoKilledBy == "PLAYER" || _tangoCaptured) && !alive stashA && !alive stashB ) then {
					_tasksTotal = "All";
				} else {
				
					//if the target was killed by a player or captured, or both stashes were destroyed, change the text to:
					if ( (_tangoKilledBy == "PLAYER" || _tangoCaptured) || (!alive stashA && !alive stashB) ) then {
						_tasksTotal = "Some";
					};
				};
				
				//format the total task text:
				_tasksTotal = format ["%1 of the operation's objectives were completed: ", _tasksTotal];
			};
			_endTextTasks = format ["%1", _tasksTotal]; 
			
			//then, explaining what seemingly happened had to the target
			_targetStatus = "The target had managed to escape"; //default, the target managed to escape
			
			//if the target was killed by the players:
			if (_tangoKilledBy == "PLAYER") then {
				if (_recognitionState == "initially") then {
					_targetStatus = "The target was later confirmed killed in the raid";
				} else {
					_targetStatus = "The target had been verified dead in the raid";
				};
			} else {
				//if the target was killed, but not by the players:
				if (killConfirmed) then {
					_targetStatus = "The target was confirmed dead";
				} else {
					if (!alive tango || side tango == civilian) then {
						_targetStatus = "The target had apparently managed to escape";
					} else {
						//if the target was captured:
						if (_tangoCaptured) then {
							_targetStatus = "The target had been successfully captured alive";
						};
					};
				};
			};
			_endTextTasks = format ["%1%2", _endTextTasks, _targetStatus];
			
			//lastly, if the cache task was assigned or both caches were destroyed, explain how well that went:
			if (_cacheTaskAssigned || (!alive stashA && !alive stashB)) then {
				_cachesStatus = "";
				
				if (!alive stashA && !alive stashB) then {
					_cachesStatus = "both weapons caches were destroyed";
					
					//if the target was killed by players or captured, AND both stashes were destroyed, or the mission was a failure, BUT stashes destroyed
					if (_tangoKilledBy == "PLAYER" || _tangoCaptured) then {
						_cachesStatus = format [", and %1", _cachesStatus];
					} else {
						_cachesStatus = format [", but %1", _cachesStatus];
					};
				} else {
					
					//if only one of the stashes was destroyed:
					if (!alive stashA || !alive stashB) then {
						_cacheStatus = "one of the weapons caches was destroyed";
						
						//if the primary objective was completed, AND one cache was destroyed, or failed, BUT one stash destroyed
						if (_tangoKilledBy == "PLAYER" || _tangoCaptured) then {
							_cachesStatus = format [", and %1", _cachesStatus];
						} else {
							_cachesStatus = format [", but %1", _cachesStatus];
						};
					} else {
					
						//if no stash was destroyed:
						_cacheStatus = "none of the weapons caches were destroyed";
						
						//if the target was not killed by players or captured, AND no caches were destroyed, or he was killed or captured, BUT no stash was destroyed:
						if (_tangoKilledBy != "PLAYER" && !_tangoCaptured) then {
							_cachesStatus = format [", and %1", _cachesStatus];
						} else {
							_cachesStatus = format [", but %1", _cachesStatus];
						};
					};
				};
				
				_endTextTasks = format ["%1%2", _endTextTasks, _cachesStatus];
			};
			
			_endTextTasks = format ["%1.", _endTextTasks]; //add period after the whole thing
			
			/*
			Third slide: combatant casualties. Describe player casualties, and enemies killed.
			If there was an assault or an ambush, explain that it is difficult to ascertain how many of the killed hostiles were due to the raid
			If the target was killed in either the ambush or the assault, add a note on that 
			*/
			
			//players: count dead players, describe casualty amount
			_casualtiesPlayers = "";
			_totalPlayers = count allPlayers;
			_deadPlayers = 0;
			{
				if (!alive _x) then {
					_deadPlayers = _deadPlayers + 1;
				};
			} forEach allPlayers;
			_percentDead = _deadPlayers/(count allPlayers);

			if (_deadPlayers == 0) then {
				_casualtiesPlayers = "no";
			} else {
				if (_percentDead < 0.3) then {
					_casualtiesPlayers = "significant";
				} else {
					if (_percentDead < 0.6) then {
						_casualtiesPlayers = "heavy";
					} else {
						_casualtiesPlayers = "catastrophic";
					};
				};
			};
			_endTextCasualties = format ["The special jaeger team suffered %1 casualties", _casualtiesPlayers];
		
			//count live hostiles, compare to live hostiles at mission start
			_liveEnemy = 0;
			{
				if (side _x == east || side _x == resistance) then {
					if (alive _x) then {
						_liveEnemy = _liveEnemy + 1;
					};
				};
			} forEach allUnits;
			_casualtiesEnemy = (_opforStart + _independentStart) - _liveEnemy;
			_endTextCasualties = format ["%1, with %2 hostile combatants killed", _endTextCasualties, _casualtiesEnemy];
			
			//describe hostile death situation
			if (count assault > 0 || ambushActivated) then {
				//if there was an ambush or an assault, make it clear it's unknown how many hostiles were killed by players
				_endTextCasualties = format ["%1 during the morning. However, other combat activity makes it difficult to estimate how many of these were a direct result of the raid", _endTextCasualties];
				
				//if the kill was not confirmed and the target was not killed by players or captured
				if (!killConfirmed && (_tangoKilledBy != "PLAYER") && !_tangoCaptured) then {
				
					//if he was killed in the ambush or by the convoy, confirm this
					if (_tangoKilledBy == "ASSAULT" || _tangoKilledBy == "CONVOY") then {
						_endTextCasualties = format ["%1. The target was later confirmed killed", _endTextCasualties];
					};
					
					//describe where the target died, or make his whereabouts unknown if he died accidentally
					switch _tangoKilledBy do {
						case "CONVOY": {
							_endTextCasualties = format ["%1 in an ambush on a UN convoy", _endTextCasualties];
						};
						
						case "ASSAULT": {
							_endTextCasualties = format ["%1 in an assault by a rival militia", _endTextCasualties];
						};
						
						case "ACCIDENT": {
							_endTextCasualties = format ["%1. The target disappeared during the morning, his status and whereabouts are still unknown", _endTextCasualties];
						};
					};
				};
			} else {
				//if there was no assault or ambush, make it clear all hostiles were killed because of the raid
				_endTextCasualties = format ["%1 in the raid", _endTextCasualties];
				
				//if the target was killed accidentally and the death was not confirmed, and there was no assault, make his status unclear 
				if (_tangoKilledBy == "ACCIDENT" && !killConfirmed) then {
					_endTextCasualties = format ["%1. The target disappeared during the morning, his status and whereabouts are still unknown", _endTextCasualties];
				};
			};
			_endTextCasualties = format ["%1.", _endTextCasualties]; //add period at end
			
			/*
			Next slide: civilian casualties. Tell the players how many civilians were killed, and assign blame either on the special jaeger team or 
			not, depending on if there was an assault
			*/
			_civiliansKilled = 0;
			_civiliansKilledByPlayers = 0;
			{
				if (!alive _x) then {
					_civilian = _x;
					_hitList = _civilian getVariable "MGP_hitList";
					_killer = _hitList select (count _hitList - 1);
					
					if (side _killer == resistance || side _killer == west) then {
						if (isPlayer _killer) then {
							_civiliansKilledByPlayers = _civiliansKilledByPlayers + 1;
						};
						
						_civiliansKilled = _civiliansKilled + 1;
					};
				};
			} forEach (civiliansA + civiliansB);
			
			_endTextCivilians = "";
			if (_civiliansKilled > 0) then {
				_endTextCivilians = format ["%1 civilians were killed", _civiliansKilled];
				if (count assault > 0) then {
					_endTextCivilians = format ["%1 during the morning's engagements", _endTextCivilians];
					if (_civiliansKilledByPlayers > 0) then {
						if (_civiliansKilledByPlayers == _civiliansKilled) then {
							_endTextCivilians = format ["%1, all of them by the special jaeger team", _endTextCivilians];
						} else {
							_endTextCivilians = format ["%1, some of them by the special jaeger team", _endTextCivilians];
						};
					};
				} else {
					if (_civiliansKilledByPlayers > 0) then {
						_endTextCivilians = format ["%1 by the special jaeger team", _endTextCivilians];
					} else {
						_endTextCivilians = format ["%1 in unclear circumstances during the morning", _endTextCivilians];
					};
				};
				_endTextCivilians = format ["%1.", _endTextCivilians];
			};
			
			//Calculate which ending to show. Possibilities: totalwin, partialwin, totalloss, partialloss
			//if the target was killed by the players, captured, or the kill was verified during the raid, then win, else loss
			_endState = "";
			if (_tangoCaptured || _tangoKilledBy == "PLAYER" || killConfirmed) then {
				_endState = "win";
			} else {
				_endState = "loss";
			};
			
			//if the cache task was assigned:
			if (_cacheTaskAssigned) then {
				//and the target was killed
				if (_endState == "win") then {
					//if both stashes were destroyed: total, else: partial
					if (!alive stashA && !alive stashB) then {
						_endState = format ["total%1", _endState];
					} else {
						_endState = format ["partial%1", _endState];
					};
				} else {
					//if the target is alive, but stashes destroyed: partial, else: total
					if (!alive stashA && !alive stashB) then {
						_endState = format ["partial%1", _endState];
					} else {
						_endState = format ["total%1", _endState];
					};
				};
			} else {
				//if the cache task was not assigned: total
				_endState = format ["total%1", _endState];
			};
			
			/*
			Final slide: ending evaluation if the players are to be specially commended or condemned
			Condemned if: civilians killed by players, heavy casualties sustained, or mission failed and casualties sustained
			Commended if: all tasks completed and the target was captured, no civilians killed, no casualties sustained
			*/
			_commendationText = "";
			_civiliansKilledByPlayers = if (_civiliansKilledByPlayers > 0) then { true; } else { false; };
			if (!_civiliansKilledByPlayers && _endState == "totalwin" && _tangoCaptured && _casualtiesPlayers == "no") then {
				_commendationText = "The special jaeger team has earned international praise for their efficiency and professionalism during this important operation.";
			} else {
				if ( _civiliansKilledByPlayers || _endState == "totalloss" || (_endState != "totalwin" && _casualtiesPlayers != "no")) then {
					_commendationText = "The decision to send such an inexperienced unit on an important mission, in an apparent attempt to get them important combat experience at the cost of the mission's success, has been heavily criticized.";
				};
			};
			_endTextPS = format ["%1", _commendationText];
			
			//Runs end.sqf on everyone. For varying mission end states, calculate the correct one here and send it as an argument for end.sqf
			[[[_endState, _endTextStatus, _endTextTasks, _endTextCasualties, _endTextCivilians, _endTextPS],"end.sqf"], "BIS_fnc_execVM", true, false] spawn BIS_fnc_MP;
		};
		//sets thingdone as true when players enter the AO
		if (!_thingDone) then {
			{
				if (alive _x && _x in list trigger_escapeArea) then {
					_thingDone = true;
				};
			} forEach playableUnits;
		};
		
		//Sets _playersDead as true if nobody is still alive
		_playersDead = true;
		{
			if (alive _x) then {
				_playersDead = false;
			};
		} forEach playableUnits;
		
		//sets playersInBase as true if everyone is in base and not in a vehicle (and not dead)
		if (!_playersDead) then {
			_playersInBase = true;
			{
				if ((alive _x) && ( !(_x in list trigger_base) || (vehicle _x != _x) )) then {
					_playersInBase = false;
				};
			} forEach playableUnits;
		};
		
		
		//sets playersescaped as true when no players are in the AO and the helicopter is destroyed
		_playersEscaped = true;
		if (!canMove heko && !_playersDead) then {
			{
				if (alive _x && _x in list trigger_escapeArea) then {
					_playersEscaped = false;
				};
			} forEach playableUnits;
		} else {
			_playersEscaped = false;
		};
		
		//displays task update when tango kill is confirmed
		if (killConfirmed && !_killTaskUpdated) then {
			["tango", "SUCCEEDED", false] call BIS_fnc_taskSetState;
			[ ["TaskSucceeded", ["Kill Confirmed"]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
			_killTaskUpdated = true;
		};
		
		//displays task update on caches when they are both destroyed
		if (!alive stashA && !alive stashB && !_destroyTaskUpdated) then {
			["caches", "SUCCEEDED", false] call BIS_fnc_taskSetState;
			[ ["TaskSucceeded", ["Caches Destroyed"]], "BIS_fnc_showNotification"] call BIS_fnc_MP;
			_destroyTaskUpdated = true;
		};
	};
};

//client inits wait for serverInit to be true before starting, to make sure all variables the server sets up are set up before clients try to refer to them (which would cause errors)
serverInit = true;
publicVariable "serverInit";
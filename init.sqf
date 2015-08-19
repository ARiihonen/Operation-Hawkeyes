//waits until the server has done its init crap
waitUntil {!isNil "serverInit"};
waitUntil {serverInit};

//Runs on both server and clients:

//ASR parameters
asr_ai3_sysdanger_radiorange = 1000; //this tells the thingy to not send AI to help out other fighting AI unless they're within 50 metres. Set to whatever you want or remove.

//Player init: this will only run on players. Use it to add the briefing and any player-specific stuff like action-menu items.
if (!isServer || (isServer && !isDedicated) ) then {
	
	//put in briefings
	brief = [] execVM "brief\briefing.sqf";
};

if (isServer) then {
	_other = execVM "ai\general.sqf";
};
//waits until the server has done its init crap
waitUntil {!isNil "serverInit"};
waitUntil {serverInit};

//TFAR parameters you might want to change. The names should be self-explanatory.
#include "\task_force_radio\functions\common.sqf";

tf_no_auto_long_range_radio = true;
tf_give_personal_radio_to_regular_soldier = true;
tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

tf_west_radio_code = "_bluefor"; //every side with the same radio code can talk to each other on radio, if on the same channel
tf_defaultWestBacpkack = "tf_bussole";
tf_defaultWestPersonalRadio = "tf_anprc148jem"; //fancy short range radio
tf_defaultWestRiflemanRadio = "tf_anprc148jem"; //shit short range radio

_settingsSwWest = false call TFAR_fnc_generateSwSettings;
_settingsSwWest set [2, ["31.10","31.15","31.20","31.25","31.90"]];
tf_freq_west = _settingsSwWest;

_settingsLrWest = false call TFAR_fnc_generateLrSettings;
_settingsLrWest set [2, ["31","32","33","40","50","51"]];
tf_freq_west_lr = _settingsLrWest;

//Runs on both server and clients:

//ASR parameters
asr_ai3_sysdanger_radiorange = 1000; //this tells the thingy to not send AI to help out other fighting AI unless they're within 50 metres. Set to whatever you want or remove.

//Player init: this will only run on players. Use it to add the briefing and any player-specific stuff like action-menu items.
if (!isServer || (isServer && !isDedicated) ) then {
	tango addAction ["<t color='#AADDAA'>Confirm kill</t>", "killConfirmed = true; publicVariableServer 'killConfirmed';", "", 6, false, true, "", "!alive _target && !killConfirmed"];
	//put in briefings
	brief = [] execVM "brief\briefing.sqf";
};

if (isServer) then {
	_other = execVM "ai\general.sqf";
};
if (typeOf _this == "rhsusf_M1078A1P2_B_wd_fmtv_usarmy" || typeOf _this == "rhsusf_rg33_wd") then {
	_this addItemCargoGlobal ["ACE_packingBandage", 100];
	_this addItemCargoGlobal ["ACE_morphine", 50];
	_this addItemCargoGlobal ["ACE_epinephrine", 50];
	_this addItemCargoGlobal ["ACE_tourniquet", 50];
	_this addItemCargoGlobal ["ACE_personalAidKit", 20];
	_this addItemCargoGlobal ["ACE_surgicalKit", 20];
	_this addItemCargoGlobal ["ACE_bloodIV", 20];
};

if (typeOf _this != "rhsusf_rg33_wd") then {
	_this addMagazineCargoGlobal ["hlc_20rnd_762x51_b_G3", 20];
	_this addMagazineCargoGlobal ["HandGrenade", 10];
	_this addMagazineCargoGlobal ["SmokeShell", 10];
};

if (typeOf _this != "rhsusf_m1025_w_m2") then {
	_this addItemCargoGlobal ["ACE_DefusalKit", 5];
	_this addItemCargoGlobal ["ACE_Clacker", 10];
	_this addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 20];
};

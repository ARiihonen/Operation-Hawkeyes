_side = side _this;
_class = toUpper (typeOf _this);

if (_class != "O_OFFICER_F") then {

	removeAllWeapons _this;
	removeAllItems _this;
	removeAllAssignedItems _this;
	removeUniform _this;
	removeVest _this;
	removeBackpack _this;

	_this setSpeaker (["rhs_Male01RUS","rhs_Male02RUS","rhs_Male03RUS","rhs_Male04RUS","rhs_Male05RUS"] select (floor random 5));

	_uniforms = "";
	_vests = "";
	_headgears = "";
	_facegears = "";
	_weapons = "";
	_squadWeapons = "";

	switch _side do {
		case civilian: {
			_uniforms = ["U_BG_Guerilla2_2","U_BG_Guerilla2_1","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_C_HunterBody_grn","TRYK_U_B_C02_Tsirt","TRYK_U_B_PCUGs_BLK_R","TRYK_U_B_PCUGs_gry_R","TRYK_U_B_PCUGs_OD_R","TRYK_shirts_DENIM_BK","TRYK_shirts_DENIM_BL","TRYK_shirts_DENIM_BWH","TRYK_shirts_DENIM_od","TRYK_shirts_DENIM_R","TRYK_shirts_DENIM_RED2","TRYK_shirts_DENIM_WH","TRYK_shirts_DENIM_WHB","TRYK_shirts_DENIM_ylb","TRYK_U_denim_hood_nc","TRYK_U_B_BLK_T_BK","TRYK_U_B_RED_T_BR","TRYK_U_B_BLK_T_WH","TRYK_U_B_Denim_T_BK","TRYK_U_B_Denim_T_WH","U_C_WorkerCoveralls","U_C_Poor_1","U_Marshal","TRYK_SUITS_BLK_F","TRYK_SUITS_BR_F"];
		};
		
		case east: {
		
			removeHeadgear _this;
			removeGoggles _this;
			
			if (_class == "O_SOLDIER_F" || _class == "O_SOLDIER_M_F" || _class == "O_SOLDIER_LAT_F" || _class == "O_SOLDIER_AR_F") then {
				_uniforms = ["TRYK_shirts_DENIM_BK","TRYK_shirts_OD_PAD_BK","MNP_CombatUniform_ASA_GC_B","MNP_CombatUniform_Militia_E","U_BG_Guerrilla_6_1","U_BG_Guerilla2_3","U_BG_Guerilla3_1"];
				_vests = ["TRYK_LOC_AK_chestrig_OD","TRYK_LOC_AK_chestrig_TAN","MNP_V_M81_Harness","MNP_V_OD_Harness","TRYK_V_ChestRig_L","TRYK_V_ChestRig"];
				_headgears = ["H_Bandanna_cbr","H_Bandanna_khk","H_Bandanna_sgg","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_tan"];
				
				_weapons = [["rhs_30Rnd_762x39mm","rhs_weap_akm",""],["rhs_30Rnd_762x39mm","rhs_weap_akms",""]];
				
				if (random 1 > 0.5) then {
					if (_class == "O_SOLDIER_M_F") then {
						_weapons = [["rhs_10Rnd_762x54mmR_7N1","rhs_weap_svd","rhs_acc_pso1m2"]];
					};
					
					if (_class == "O_SOLDIER_AR_F") then {
						_weapons = "";
						_squadWeapons = ["rhs_100Rnd_762x54mmR","rhs_weap_pkm","rhs_sidor"];
					};
					
					if (_class == "O_SOLDIER_LAT_F") then {
						_squadWeapons = if (random 1 > 0.25) then { ["rhs_rpg7_PG7VL_mag","rhs_weap_rpg7","rhs_rpg_empty"]; } else { ["rhs_fim92_mag","rhs_weap_fim92","rhs_rpg_empty"]; };
					};
				};
			};
			
			if (_class == "O_SOLDIERU_F" || _class == "O_SOLDIERU_M_F" || _class == "O_SOLDIERU_SL_F" || _class == "O_SOLDIERU_TL_F") then {
				_uniforms = ["TRYK_U_B_PCUGs_BLK_R","TRYK_U_B_Wood_PCUs_R","TRYK_U_pad_hood_Cl"];
				_vests = ["MNP_Vest_Black_Tac_B","MNP_Vest_M81b","MNP_Vest_OD_B","MNP_Vest_UKR_B","TRYK_V_Sheriff_BA_TB","TRYK_V_Sheriff_BA_T"];
				_headgears = ["H_Bandanna_khk_hs","H_Watchcap_blk","H_Booniehat_khk_hs","H_Cap_oli_hs","MNP_MC_UKR"];
				
				if (_class == "O_SOLDIERU_M_F") then {
					_weapons = [["rhs_10Rnd_762x54mmR_7N1","rhs_weap_svds_npz","optic_AMS"]];
				} else {
					_weapons = [["rhs_30Rnd_762x39mm","rhs_weap_ak103","rhs_acc_pkas"],["rhs_30Rnd_545x39_AK","rhs_weap_ak74m_2mag","rhs_acc_pkas"]];
				};
				
				_this addItem "ItemRadio";
			};
		};

		case resistance: {
		
			removeHeadgear _this;
			removeGoggles _this;
			
			_uniforms = ["TRYK_shirts_DENIM_BK","TRYK_shirts_OD_PAD_BK","MNP_CombatUniform_ASA_GC_B","MNP_CombatUniform_Militia_E","U_BG_Guerrilla_6_1","U_BG_Guerilla2_3","U_BG_Guerilla3_1"];
			_vests = ["TRYK_LOC_AK_chestrig_OD","TRYK_LOC_AK_chestrig_TAN","MNP_V_M81_Harness","MNP_V_OD_Harness","TRYK_V_ChestRig_L","TRYK_V_ChestRig"];
			_headgears = ["H_Bandanna_cbr","H_Bandanna_khk","H_Bandanna_sgg","H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_tan"];
			
			_weapons = [["rhs_30Rnd_762x39mm","rhs_weap_akm",""],["rhs_30Rnd_762x39mm","rhs_weap_akms",""]];
			if (_class == "I_SOLDIER_M_F") then {
				_weapons = [["rhs_10Rnd_762x54mmR_7N1","rhs_weap_svd","rhs_acc_pso1m2"]];
			};
			
			if (_class == "I_SOLDIER_AR_F") then {
				_weapons = "";
				_squadWeapons = ["rhs_100Rnd_762x54mmR","rhs_weap_pkm","rhs_sidor"];
			};
			
			if (_class == "I_SOLDIER_LAT_F") then {
				_squadWeapons = ["rhs_rpg7_PG7VL_mag","rhs_weap_rpg7","rhs_rpg_empty"];
			};
		};
	};

	if (typeName _uniforms == "ARRAY") then {
		_this forceAddUniform (_uniforms select floor random count _uniforms);
	};

	if (typeName _vests == "ARRAY") then {
		_this addVest (_vests select floor random count _vests);
	};

	if (typeName _headgears == "ARRAY") then {
		if (random 1 > 0.5) then {
			_this addHeadgear (_headGears select floor random count _headgears);
		};
	};

	if (typeName _facegears == "ARRAY") then {
		if (random 1 > 0.75) then {
			_this addGoggles (_facegears select floor random count _facegears);
		};
	};

	if (typeName _weapons == "ARRAY") then {
		_weapon = _weapons select floor random count _weapons;
		_this addMagazines [_weapon select 0, 6];
		_this addWeapon (_weapon select 1);
		if (_weapon select 2 != "") then {
			_this addPrimaryWeaponItem (_weapon select 2);
		};
	};

	if (typeName _squadWeapons == "ARRAY") then {
		_weapon = _squadWeapons;
		_this addBackpack (_weapon select 2);
		_this addMagazines [_weapon select 0, 4];
		_this addWeapon (_weapon select 1);
	};
} else {
	comment "Remove existing items";
	removeAllWeapons _this;
	removeAllItems _this;
	removeAllAssignedItems _this;
	removeUniform _this;
	removeVest _this;
	removeBackpack _this;
	removeHeadgear _this;
	removeGoggles _this;

	comment "Add containers";
	_this forceAddUniform "TRYK_U_denim_jersey_blu";
	for "_i" from 1 to 2 do {_this addItemToUniform "rhs_mag_an_m14_th3";};
	_this addVest "V_BandollierB_blk";
	for "_i" from 1 to 6 do {_this addItemToVest "hlc_30Rnd_545x39_B_AK";};
	_this addHeadgear "H_Cap_blu";
	_this addGoggles "G_Sport_Blackred";

	comment "Add weapons";
	_this addWeapon "hlc_rifle_aek971";
	_this addPrimaryWeaponItem "hlc_optic_kobra";
	_this addWeapon "Binocular";

	comment "Add items";
	_this linkItem "ItemMap";
	_this linkItem "ItemCompass";
	_this linkItem "ItemWatch";
	_this linkItem "ItemRadio";

	comment "Set identity";
	_this setFace "PersianHead_A3_02";
	_this setSpeaker "rhs_Male02RUS";
};
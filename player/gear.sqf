//get player class and make sure it's all uppercase since BI classnames are super inconsistent
_class = typeOf player;
_class = toUpper _class;

comment "Remove existing items";
removeAllWeapons player;
removeAllItems player;
removeAllAssignedItems player;
removeUniform player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;

switch _class do {

	case "B_RECON_TL_F": { 
		comment "Exported from Arsenal by Caranfin";
		comment "Add containers";
		player forceAddUniform "MNP_CombatUniform_Fin_A";
		player addItemToUniform "ACE_EarPlugs";
		player addItemToUniform "ACE_microDAGR";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_morphine";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_epinephrine";};
		for "_i" from 1 to 2 do {player addItemToUniform "ACE_elasticBandage";};
		player addItemToUniform "ACE_tourniquet";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_packingBandage";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_CableTie";};
		player addVest "TRYK_V_tacv10LC_OD";
		player addItemToVest "ACE_MapTools";
		for "_i" from 1 to 2 do {player addItemToVest "ACE_CableTie";};
		for "_i" from 1 to 7 do {player addItemToVest "hlc_30Rnd_545x39_B_AK";};
		for "_i" from 1 to 2 do {player addItemToVest "SmokeShell";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m67";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_green";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_an_m8hc";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_red";};
		for "_i" from 1 to 2 do {player addItemToVest "16Rnd_9x21_Mag";};
		player addBackpack "tf_bussole";
		player addHeadgear "MNP_Boonie_FIN";
		player addGoggles "TRYK_Shemagh_G";

		comment "Add weapons";
		player addWeapon "hlc_rifle_ak12";
		player addPrimaryWeaponItem "hlc_muzzle_545SUP_AK";
		player addPrimaryWeaponItem "rhsusf_acc_anpeq15A";
		player addPrimaryWeaponItem "rhsusf_acc_ACOG3";
		player addWeapon "hgun_P07_F";
		player addWeapon "Leupold_Mk4";

		comment "Add items";
		player linkItem "ItemMap";
		player linkItem "ItemCompass";
		player linkItem "ItemWatch";
		player linkItem "tf_anprc148jem";
		player linkItem "NVGoggles_OPFOR";
	};
	
	case "B_RECON_MEDIC_F": {
		comment "Add containers";
		player forceAddUniform "MNP_CombatUniform_Fin_A";
		player addItemToUniform "ACE_EarPlugs";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_morphine";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_epinephrine";};
		for "_i" from 1 to 2 do {player addItemToUniform "ACE_elasticBandage";};
		player addItemToUniform "ACE_tourniquet";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_packingBandage";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_CableTie";};
		player addVest "TRYK_V_tacv10LC_OD";
		player addItemToVest "ACE_MapTools";
		for "_i" from 1 to 2 do {player addItemToVest "ACE_CableTie";};
		for "_i" from 1 to 8 do {player addItemToVest "hlc_30Rnd_545x39_B_AK";};
		for "_i" from 1 to 2 do {player addItemToVest "SmokeShell";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m67";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_green";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_an_m8hc";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_red";};
		for "_i" from 1 to 2 do {player addItemToVest "16Rnd_9x21_Mag";};
		player addBackpack "B_AssaultPack_rgr";
		for "_i" from 1 to 20 do {player addItemToBackpack "ACE_packingBandage";};
		for "_i" from 1 to 20 do {player addItemToBackpack "ACE_elasticBandage";};
		for "_i" from 1 to 4 do {player addItemToBackpack "ACE_tourniquet";};
		for "_i" from 1 to 10 do {player addItemToBackpack "ACE_morphine";};
		for "_i" from 1 to 10 do {player addItemToBackpack "ACE_epinephrine";};
		player addItemToBackpack "ACE_personalAidKit";
		player addItemToBackpack "ACE_surgicalKit";
		for "_i" from 1 to 5 do {player addItemToBackpack "ACE_bloodIV";};
		player addHeadgear "MNP_Boonie_FIN";
		player addGoggles "TRYK_Shemagh_G";

		comment "Add weapons";
		player addWeapon "hlc_rifle_ak12";
		player addPrimaryWeaponItem "rhsusf_acc_anpeq15A";
		player addPrimaryWeaponItem "rhsusf_acc_ACOG";
		player addWeapon "hgun_P07_F";

		comment "Add items";
		player linkItem "ItemMap";
		player linkItem "ItemCompass";
		player linkItem "ItemWatch";
		player linkItem "tf_anprc148jem";
		player linkItem "NVGoggles_OPFOR";
	};
	
	case "B_RECON_F": {
		comment "Add containers";
		player forceAddUniform "MNP_CombatUniform_Fin_A";
		player addItemToUniform "ACE_EarPlugs";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_morphine";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_epinephrine";};
		for "_i" from 1 to 2 do {player addItemToUniform "ACE_elasticBandage";};
		player addItemToUniform "ACE_tourniquet";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_packingBandage";};
		for "_i" from 1 to 2 do {player addItemToUniform "16Rnd_9x21_Mag";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_CableTie";};
		player addVest "TRYK_V_tacv10LC_OD";
		player addItemToVest "ACE_MapTools";
		for "_i" from 1 to 2 do {player addItemToVest "ACE_CableTie";};
		for "_i" from 1 to 8 do {player addItemToVest "hlc_30Rnd_545x39_B_AK";};
		for "_i" from 1 to 2 do {player addItemToVest "SmokeShell";};
		for "_i" from 1 to 5 do {player addItemToVest "rhs_mag_m67";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_green";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_an_m8hc";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_red";};
		for "_i" from 1 to 5 do {player addItemToVest "ACE_M84";};
		player addHeadgear "MNP_Boonie_FIN";
		player addGoggles "TRYK_Shemagh_G";

		comment "Add weapons";
		player addWeapon "hlc_rifle_ak12";
		player addPrimaryWeaponItem "rhsusf_acc_anpeq15A";
		player addPrimaryWeaponItem "rhsusf_acc_compm4";
		player addWeapon "hgun_P07_F";

		comment "Add items";
		player linkItem "ItemMap";
		player linkItem "ItemCompass";
		player linkItem "ItemWatch";
		player linkItem "tf_anprc148jem";
		player linkItem "NVGoggles_OPFOR";

	};
	
	case "B_RECON_EXP_F": {
		comment "Add containers";
		player forceAddUniform "MNP_CombatUniform_Fin_A";
		player addItemToUniform "ACE_EarPlugs";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_morphine";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_epinephrine";};
		for "_i" from 1 to 2 do {player addItemToUniform "ACE_elasticBandage";};
		player addItemToUniform "ACE_tourniquet";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_packingBandage";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_CableTie";};
		player addVest "TRYK_V_tacv10LC_OD";
		player addItemToVest "ACE_MapTools";
		for "_i" from 1 to 2 do {player addItemToVest "ACE_CableTie";};
		for "_i" from 1 to 8 do {player addItemToVest "hlc_30Rnd_545x39_B_AK";};
		for "_i" from 1 to 2 do {player addItemToVest "SmokeShell";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m67";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_green";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_an_m8hc";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_red";};
		for "_i" from 1 to 2 do {player addItemToVest "16Rnd_9x21_Mag";};
		player addBackpack "B_AssaultPack_rgr";
		player addItemToBackpack "ACE_DefusalKit";
		player addItemToBackpack "ACE_Clacker";
		for "_i" from 1 to 5 do {player addItemToBackpack "DemoCharge_Remote_Mag";};
		for "_i" from 1 to 2 do {player addItemToBackpack "ClaymoreDirectionalMine_Remote_Mag";};
		player addHeadgear "MNP_Boonie_FIN";
		player addGoggles "TRYK_Shemagh_G";

		comment "Add weapons";
		player addWeapon "hlc_rifle_ak12";
		player addPrimaryWeaponItem "rhsusf_acc_anpeq15A";
		player addPrimaryWeaponItem "rhsusf_acc_ACOG3";
		player addWeapon "hgun_P07_F";

		comment "Add items";
		player linkItem "ItemMap";
		player linkItem "ItemCompass";
		player linkItem "ItemWatch";
		player linkItem "tf_anprc148jem";
		player linkItem "NVGoggles_OPFOR";
	};
	
	case "B_RECON_SHARPSHOOTER_F": {
		comment "Add containers";
		player forceAddUniform "MNP_CombatUniform_Fin_A";
		player addItemToUniform "ACE_EarPlugs";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_morphine";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_epinephrine";};
		for "_i" from 1 to 2 do {player addItemToUniform "ACE_elasticBandage";};
		player addItemToUniform "ACE_tourniquet";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_packingBandage";};
		player addItemToUniform "ACE_MapTools";
		player addItemToUniform "ACE_Kestrel4500";
		player addItemToUniform "ACE_RangeCard";
		player addItemToUniform "ACE_microDAGR";
		for "_i" from 1 to 2 do {player addItemToUniform "16Rnd_9x21_Mag";};
		player addVest "TRYK_V_tacv1";
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m67";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_green";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_an_m8hc";};
		for "_i" from 1 to 6 do {player addItemToVest "hlc_5rnd_300WM_FMJ_AWM";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_yellow";};
		player addBackpack "B_TacticalPack_rgr";
		player addItemToBackpack "hlc_smg_mp5a3";
		player addItemToBackpack "optic_Aco_smg";
		for "_i" from 1 to 5 do {player addItemToBackpack "hlc_30Rnd_9x19_B_MP5";};
		player addHeadgear "MNP_Boonie_FIN";
		player addGoggles "TRYK_Shemagh_G";

		comment "Add weapons";
		player addWeapon "hlc_rifle_awmagnum";
		player addPrimaryWeaponItem "rhsusf_acc_LEUPOLDMK4";
		player addWeapon "hgun_P07_F";
		player addWeapon "ACE_Vector";

		comment "Add items";
		player linkItem "ItemMap";
		player linkItem "ItemCompass";
		player linkItem "ItemWatch";
		player linkItem "tf_anprc148jem";
		player linkItem "NVGoggles_OPFOR";
	};
	
	case "B_RECON_M_F": {
		comment "Add containers";
		player forceAddUniform "MNP_CombatUniform_Fin_A";
		player addItemToUniform "ACE_EarPlugs";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_morphine";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_epinephrine";};
		for "_i" from 1 to 2 do {player addItemToUniform "ACE_elasticBandage";};
		player addItemToUniform "ACE_tourniquet";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_packingBandage";};
		player addItemToUniform "ACE_MapTools";
		player addItemToUniform "ACE_Kestrel4500";
		player addItemToUniform "ACE_RangeCard";
		player addItemToUniform "ACE_microDAGR";
		player addItemToUniform "Leupold_Mk4";
		player addVest "TRYK_V_tacv1";
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_green";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_an_m8hc";};
		for "_i" from 1 to 2 do {player addItemToVest "rhs_mag_m18_yellow";};
		for "_i" from 1 to 6 do {player addItemToVest "hlc_30Rnd_545x39_B_AK";};
		for "_i" from 1 to 2 do {player addItemToVest "16Rnd_9x21_Mag";};
		player addBackpack "B_Kitbag_rgr";
		player addItemToBackpack "ACE_Tripod";
		player addItemToBackpack "ACE_DefusalKit";
		for "_i" from 1 to 10 do {player addItemToBackpack "ACE_packingBandage";};
		for "_i" from 1 to 10 do {player addItemToBackpack "ACE_elasticBandage";};
		for "_i" from 1 to 2 do {player addItemToBackpack "ACE_tourniquet";};
		for "_i" from 1 to 5 do {player addItemToBackpack "ACE_morphine";};
		for "_i" from 1 to 5 do {player addItemToBackpack "ACE_epinephrine";};
		for "_i" from 1 to 5 do {player addItemToBackpack "ACE_bloodIV";};
		player addItemToBackpack "ACE_personalAidKit";
		player addItemToBackpack "ACE_surgicalKit";
		for "_i" from 1 to 4 do {player addItemToBackpack "APERSTripMine_Wire_Mag";};
		player addHeadgear "MNP_Boonie_FIN";
		player addGoggles "TRYK_Shemagh_G";

		comment "Add weapons";
		player addWeapon "hlc_rifle_ak12";
		player addPrimaryWeaponItem "hlc_muzzle_545SUP_AK";
		player addPrimaryWeaponItem "rhsusf_acc_anpeq15A";
		player addPrimaryWeaponItem "optic_MRCO";
		player addWeapon "hgun_P07_F";
		player addWeapon "ACE_Vector";

		comment "Add items";
		player linkItem "ItemMap";
		player linkItem "ItemCompass";
		player linkItem "ItemWatch";
		player linkItem "tf_anprc148jem";
		player linkItem "NVGoggles_OPFOR";
	};
	
	case "B_HELIPILOT_F": {
		comment "Add containers";
		player forceAddUniform "TRYK_OVERALL_SAGE_BLKboots_nk_blk2";
		player addItemToUniform "ACE_MapTools";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_packingBandage";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_elasticBandage";};
		player addItemToUniform "ACE_tourniquet";
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_morphine";};
		for "_i" from 1 to 4 do {player addItemToUniform "ACE_epinephrine";};
		player addItemToUniform "ACE_microDAGR";
		player addItemToUniform "ACE_IR_Strobe_Item";
		for "_i" from 1 to 2 do {player addItemToUniform "Chemlight_blue";};
		player addVest "TRYK_Hrp_vest_od";
		player addItemToVest "ACE_EarPlugs";
		for "_i" from 1 to 2 do {player addItemToVest "16Rnd_9x21_Mag";};
		for "_i" from 1 to 2 do {player addItemToVest "hlc_30Rnd_9x19_B_MP5";};
		for "_i" from 1 to 2 do {player addItemToVest "SmokeShellBlue";};
		player addItemToVest "B_IR_Grenade";
		player addHeadgear "rhsusf_hgu56p_mask";

		comment "Add weapons";
		player addWeapon "hlc_smg_mp5a3";
		player addWeapon "hgun_P07_F";

		comment "Add items";
		player linkItem "ItemMap";
		player linkItem "ItemCompass";
		player linkItem "ItemWatch";
		player linkItem "tf_anprc148jem";
		player linkItem "NVGoggles_OPFOR";
	};
};
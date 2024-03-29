//Use in Zeus Execute Code : [_this select 0, "SetMedium",["C_Soldier_VR_F", "C_man_shorts_2_F","C_Man_casual_4_F"]] execVM "TOM_PatientSpawn.sqf";
params [
	"_spawnPos", //3D pos stripped to 2d pos
	["_injurType", "RandMedium"], // Type of casualty : SetLight, SetMedium, SetHigh, SetKIA, SetUncon, SetNone, RandLight, RandMedium, RandHigh
	["_numberPatient", 1], // Number of patients
	["_unitType",["C_Soldier_VR_F"]] // Array of possible unit types  
	];
private _counterPatient = 0;
private _counterInjuries = 0;
private _randomSkip = 0;
private _woundCOunt = 0;
private _bodypart = ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"];
private _damageType = ["bullet", "grenade", "explosive", "shell", "vehiclecrash", "backblast", "stab", "punch", "falling", "unknown"];

//Group creation
_Grp = createGroup civilian;
_handler = [_spawnPos select 0, _spawnPos select 1];

for "i" from 1 to _numberPatient do
	{
	//Unit creation, check BI documentation for spawning in vehicle
	_selectedType = selectRandom _unitType;
	_unit = _Grp createUnit [_selectedType, _handler,[], 5, "NONE"];
	[_unit, true] call ACE_captives_fnc_setHandcuffed; 
	[_unit, "FSM"] remoteExec ["disableAI", 0]; 

	//the not fun part
	switch (_injurType) do
		{
		case "SetMedium":
			{
			_flag = 1;
			[_unit, 0.7, "Head", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.5, "Head", "backblast"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.3, "Body", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.3, "Body", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.3, "Body", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.5, "RightArm", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.2, "RightLeg", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.2, "RightLeg", "explosive"] call ace_medical_fnc_addDamageToUnit;
			};
		case "SetArm":
			{
			_flag = 1;
			[_unit, 0.4, "LeftArm", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.4, "LeftArm", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.4, "LeftArm", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.4, "LeftArm", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.6, "LeftArm", "bullet"] call ace_medical_fnc_addDamageToUnit;
			[_unit, 0.4, "LeftArm", "bullet"] call ace_medical_fnc_addDamageToUnit;
			};	
		case "SetNone":
			{
			_randomSkip = 1;
			};
		case "SetKIA":
			 {
			_randomSkip = 1;
			_unit setdamage 1;
			};
		case "SetUncon":
			{
			_randomSkip = 1;
			[_unit, true, 3600] call ace_medical_fnc_setUnconscious;
			};
			case "RandHeavy":
			{
			_woundCount = 15;
			_damageType = ["bullet", "grenade", "explosive", "shell", "vehiclecrash", "backblast", "stab", "punch", "falling", "unknown"];		
			};
		case "RandMedium":
			{
			_woundCount = 6;
			_damageType = ["bullet", "grenade", "explosive", "shell", "vehiclecrash", "backblast", "stab", "punch", "falling", "unknown"];		
			};
		case "RandLight":
			{
			_woundCount = 2;
			_damageType = ["bullet", "grenade", "explosive", "shell", "vehiclecrash", "backblast", "stab", "punch", "falling", "unknown"];		
			};
		};

	//the fun part of the not fun part
	if ( _randomSkip == 0) then
		{
		_counter = 0;
		while {_counter <= _woundCount} do
			{
				_targetPart = _bodypart call BIS_fnc_selectRandom;
				_size = 0.2 + random 0.6;
				_selectedWound = _damageType call BIS_fnc_selectRandom;	
				[_unit, _size, _targetPart, _selectedWound] call ace_medical_fnc_addDamageToUnit;
				_counter = _counter + 1;	
			};
		};
	};

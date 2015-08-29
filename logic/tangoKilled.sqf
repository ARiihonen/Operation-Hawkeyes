_killed = _this select 0;
_killer = _this select 1;

if (isPlayer _killer) then {
	tangoKilledBy = "player";
} else {
	switch (side _killer) do {
		case west: {
			tangoKilledBy = "convoy";
		};
		
		case resistance: {
			tangoKilledBy = "assault";
		};
		
		default {
			tangoKilledBy = "accident";
		};
	};
};
dnct_fnc_getRandomPlayerPos = {
	_position = getPos ( selectRandom ((call BIS_fnc_listPlayers) select { alive _x }) );
	_position
}
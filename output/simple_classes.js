// auto generated atom module simple_types

// late bound classes, allow these to be declared in any order
let forward_types = {};

// define all single and product types (constructable)
class loading {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

class title {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

class character {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

class map {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

class encounter {
	constructor (level, difficulty, zone) {
		this._values = {
			level: level,
			difficulty: difficulty,
			zone: zone,
		};
	}

	get level() {
		return this._values.level;
	}

	get difficulty() {
		return this._values.difficulty;
	}

	get zone() {
		return this._values.zone;
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		if (other.level != this.level) { return false; }
		if (other.difficulty != this.difficulty) { return false; }
		if (other.zone != this.zone) { return false; }
		return true;
	}
}

class difficulty {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

class map_zone {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

class valid {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

class invalid {
	constructor () {
	}

	equals (other) {
		if (other.type != this.type) { return false; }
		return true;
	}
}

// define all sum types (not constructable)
class player_state {
	constructor () {
		throw new TypeError('cannot construct sum value player_state');
	}
}

// static type checking
forward_types['player_state'] = player_state;
player_state.type = player_state;
player_state.types = [loading, title, character, map, encounter];
player_state.is = function (value) { return [loading, title, character, map, encounter].find(t => t == player_state) != undefined;

forward_types['loading'] = loading;
loading.type = loading;
loading.types = [loading];
loading.is = function (value) { return value.type == loading};

forward_types['title'] = title;
title.type = title;
title.types = [title];
title.is = function (value) { return value.type == title};

forward_types['character'] = character;
character.type = character;
character.types = [character];
character.is = function (value) { return value.type == character};

forward_types['map'] = map;
map.type = map;
map.types = [map];
map.is = function (value) { return value.type == map};

forward_types['encounter'] = encounter;
encounter.type = encounter;
encounter.types = [encounter];
encounter.is = function (value) { return value.type == encounter};

forward_types['difficulty'] = difficulty;
difficulty.type = difficulty;
difficulty.types = [difficulty];
difficulty.is = function (value) { return value.type == difficulty};

forward_types['map_zone'] = map_zone;
map_zone.type = map_zone;
map_zone.types = [map_zone];
map_zone.is = function (value) { return value.type == map_zone};

forward_types['valid'] = valid;
valid.type = valid;
valid.types = [valid];
valid.is = function (value) { return value.type == valid};

forward_types['invalid'] = invalid;
invalid.type = invalid;
invalid.types = [invalid];
invalid.is = function (value) { return value.type == invalid};


// export as module
export { to_json, from_json, player_state, loading, title, character, map, encounter, difficulty, map_zone, valid, invalid };

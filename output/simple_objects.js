// auto generated atom module simple_types
// using tagged frozen object instances

// forward declare a type map of all types to all types as required
const type_map = new Map();

function player_state () {
	throw new TypeError('cannot construct sum value player_state');
}

function loading () {
	const obj = {
		type: 'loading',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function title () {
	const obj = {
		type: 'title',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function character () {
	const obj = {
		type: 'character',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function map () {
	const obj = {
		type: 'map',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function encounter (level, difficulty, zone) {
	const obj = {
		type: 'encounter',
		level: level,
		difficulty: difficulty,
		zone: zone,
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			if (other.level != this.level) { return false; }
			if (other.difficulty != this.difficulty) { return false; }
			if (other.zone != this.zone) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function difficulty () {
	const obj = {
		type: 'difficulty',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function map_zone () {
	const obj = {
		type: 'map_zone',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function valid () {
	const obj = {
		type: 'valid',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

function invalid () {
	const obj = {
		type: 'invalid',
		is (type) {
			return type_map.get(this.type).has(type);
		},
		equals (other) {
			if (other.type != this.type) { return false; }
			return true;
		}
	}
	Object.freeze(obj);
	return obj;
}

// add references to the type map, to answer if an object _is_ of any suggested type
type_map.set('loading', new Set());
type_map.get('loading').add('loading');
type_map.get('loading').add(loading);
type_map.get('loading').add('player_state');
type_map.get('loading').add(player_state);
type_map.set('title', new Set());
type_map.get('title').add('title');
type_map.get('title').add(title);
type_map.get('title').add('player_state');
type_map.get('title').add(player_state);
type_map.set('character', new Set());
type_map.get('character').add('character');
type_map.get('character').add(character);
type_map.get('character').add('player_state');
type_map.get('character').add(player_state);
type_map.set('map', new Set());
type_map.get('map').add('map');
type_map.get('map').add(map);
type_map.get('map').add('player_state');
type_map.get('map').add(player_state);
type_map.set('encounter', new Set());
type_map.get('encounter').add('encounter');
type_map.get('encounter').add(encounter);
type_map.get('encounter').add('player_state');
type_map.get('encounter').add(player_state);
type_map.set('difficulty', new Set());
type_map.get('difficulty').add('difficulty');
type_map.get('difficulty').add(difficulty);
type_map.set('map_zone', new Set());
type_map.get('map_zone').add('map_zone');
type_map.get('map_zone').add(map_zone);
type_map.set('valid', new Set());
type_map.get('valid').add('valid');
type_map.get('valid').add(valid);
type_map.set('invalid', new Set());
type_map.get('invalid').add('invalid');
type_map.get('invalid').add(invalid);

// string or constructor to type string
function type (string_or_constructor) {
	if(string_or_constructor == player_state) {
		return 'player_state'
	} else if(string_or_constructor == loading) {
		return 'loading'
	} else if(string_or_constructor == title) {
		return 'title'
	} else if(string_or_constructor == character) {
		return 'character'
	} else if(string_or_constructor == map) {
		return 'map'
	} else if(string_or_constructor == encounter) {
		return 'encounter'
	} else if(string_or_constructor == difficulty) {
		return 'difficulty'
	} else if(string_or_constructor == map_zone) {
		return 'map_zone'
	} else if(string_or_constructor == valid) {
		return 'valid'
	} else if(string_or_constructor == invalid) {
		return 'invalid'
	} else {
		return string_or_constructor;
	}
}

// associate the type string with the exported funciton
player_state.type = 'player_state'
loading.type = 'loading'
title.type = 'title'
character.type = 'character'
map.type = 'map'
encounter.type = 'encounter'
difficulty.type = 'difficulty'
map_zone.type = 'map_zone'
valid.type = 'valid'
invalid.type = 'invalid'

// any special handling to serialised and deserialised consistently
function to_json (atom) {
	return JSON.stringify(atom);
}

function from_json (json) {
	let obj = JSON.parse(json);
	Object.freeze(obj);
	return obj;
}


// export as module
export { to_json, from_json, player_state, loading, title, character, map, encounter, difficulty, map_zone, valid, invalid };

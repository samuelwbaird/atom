// auto generated atom module simple_types
// using tagged frozen object instances

// forward declare a type map of all types to all types as required
const type_map = new Map();

function player_state () {
	throw new TypeError('cannot construct sum value player_state');
}

function loading () {
	const obj = {
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
type_map.set('loading') = new Set();
type_map.get('loading').add('loading');
type_map.get('loading').add(loading);
type_map.get('loading').add('player_state');
type_map.get('loading').add(player_state);
type_map.set('title') = new Set();
type_map.get('title').add('title');
type_map.get('title').add(title);
type_map.get('title').add('player_state');
type_map.get('title').add(player_state);
type_map.set('character') = new Set();
type_map.get('character').add('character');
type_map.get('character').add(character);
type_map.get('character').add('player_state');
type_map.get('character').add(player_state);
type_map.set('map') = new Set();
type_map.get('map').add('map');
type_map.get('map').add(map);
type_map.get('map').add('player_state');
type_map.get('map').add(player_state);
type_map.set('encounter') = new Set();
type_map.get('encounter').add('encounter');
type_map.get('encounter').add(encounter);
type_map.get('encounter').add('player_state');
type_map.get('encounter').add(player_state);
type_map.set('difficulty') = new Set();
type_map.get('difficulty').add('difficulty');
type_map.get('difficulty').add(difficulty);
type_map.set('map_zone') = new Set();
type_map.get('map_zone').add('map_zone');
type_map.get('map_zone').add(map_zone);
type_map.set('valid') = new Set();
type_map.get('valid').add('valid');
type_map.get('valid').add(valid);
type_map.set('invalid') = new Set();
type_map.get('invalid').add('invalid');
type_map.get('invalid').add(invalid);

// export as module
export { to_json, from_json, player_state, loading, title, character, map, encounter, difficulty, map_zone, valid, invalid };

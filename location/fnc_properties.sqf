// Returns all properties of a given type.

// one parameter, the location type
private _properties = ["type", "position", "size", "side", "garrison",
                       "spawned", "forced_spawned", "despawning", "combatMode", "behaviour"];
switch (_this) do {
    case "city": {
        _properties append ["population","FIAsupport","AAFsupport","roads"];
        };
    case "base": {
        _properties append ["busy"];
    };
    case "airfield": {
        _properties append ["busy"];
    };
    case "seaport": {
        _properties append ["busy"];
    };
    case "resource": {
        _properties append ["busy"];
    };
    case "factory": {
        _properties append ["busy"];
    };
    case "camp": {  // the camp has a name
        _properties append ["name"];
    };
    case "minefield": {
        _properties append ["mines", "found"];  // [[type, pos, dir], bool]
        _properties = _properties - ["garrison", "combatMode", "behaviour"];
    };
    case "roadblock": {
        _properties append ["location"];  // the associated location of the roadblock
    };
    default {
    };
};
_properties

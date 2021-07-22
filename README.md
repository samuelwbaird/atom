# atom
Experimenting with a small DSL defining tagged immutable types. This is not intended to be an exhaustive, or particularly correct, approach to the topic, just focusing on the subset of the problem that is relevant and interesting to me.

My personal use case is defining immutatable states and messages to be shared at the boundaries of separate stateful layers in online game development, eg. between a multiplayer game server, client side representation of the game world, and stateful UI elements.

My targets are Lua, ES6 Javascript and C#, outputs for each platform may reflect niche opinions and use cases, but should be expandable.

## How to run atom

    lua atom.lua --input=<atom_file> --output=<output_source_code> --format=lua --name=<output_module_or_type_name>

### Formats

Formats in developments are as follows:

* lua
* js
* cs_tagged (implemented using a single rich tagged type, more behaviourally equivalent to the dynamic languages)
* cs_types (implemented using )


## The DSL
An atom can be mentioned anywhere in the document, and is automatically included on first mention.

> loading

One of the mentions can optionally be a definition of that atom.  
Defintions are either short form, where an atom is a sum type of other atoms.

> player_state: loading, title, playing

Or long form where an atom is a product type, in which case each component is a named, typed, field.

> playing {  
>   level: int,  
>   difficulty:  difficulty,  
> }

Definitions can be built from the following assumed primitive types:

* string
* boolean
* int
* number

Definitions can also freely reference other atoms, definitions can be arbitrarily recursive, even though the file format is not.

> example TBD

And include lists of a given type or atom:

> example TBD

TODO: define validation parameters (eg optional fields, and default value)

### Syntax

All input is case sensitive.  
Atom names and field names must start with any alphabetic character, and then a contiguous string of alphanumeric or underscore characters.  
Lines beginning with #, -- or // are treated as comments.  
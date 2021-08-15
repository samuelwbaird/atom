#! /bin/bash

lua atom.lua --input=examples/simple.atom --output=output/simple.lua --format=lua 
lua atom.lua --input=examples/simple.atom --output="output/simple_classes.js" --format=jsc --name="simple_types"
lua atom.lua --input=examples/simple.atom --output="output/simple_objects.js" --format=jso --name="simple_types"

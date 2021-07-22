#! /bin/bash

lua atom.lua --input=examples/simple.atom --output=output/simple.lua --format=lua 
lua atom.lua --input=examples/simple.atom --output="output/simple.js" --format=js --name="simple_types"

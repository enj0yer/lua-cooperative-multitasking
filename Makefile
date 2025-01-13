LUAPATH = 

.PHONY = example printing

example:
	$(LUAPATH) example.lua

printing:
	$(LUAPATH) printing-example.lua
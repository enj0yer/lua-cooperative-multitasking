LUAPATH = 

ENTRY = example.lua

OPTIONS = 

example: $(ENTRY)
	$(LUAPATH) $(ENTRY)

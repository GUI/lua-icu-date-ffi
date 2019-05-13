.PHONY: test

test:
	luarocks make --local icu-date-ffi-git-1.rockspec
	busted spec

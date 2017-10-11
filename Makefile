.PHONY: test

test:
	luarocks make --local icu-date-git-1.rockspec
	busted spec

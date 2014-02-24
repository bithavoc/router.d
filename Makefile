DC=dmd
OS_NAME=$(shell uname -s)
MH_NAME=$(shell uname -m)
DFLAGS=
ifeq (${DEBUG}, 1)
	DFLAGS=-debug -gc -gs -g
else
	DFLAGS=-O -release -inline -noboundscheck
endif
ifeq (${OS_NAME},Darwin)
	DFLAGS+=-L-framework -LCoreServices 
endif
lib_build_params=../out/router.o ../out/events.d.a -I../out/di
build: router

test: test/*.d router
	$(DC) -ofout/tests.app -main -unittest -Iout/di out/router.a out/events.d.a test/*.d $(DFLAGS)
	chmod +x out/tests.app
	out/tests.app

router: lib/*.d deps/events.d
	mkdir -p out
	cd lib; $(DC) -Hd../out/di/ -of$(lib_build_params) -op -c *.d $(DFLAGS)
	ar -r out/router.a out/router.o

.PHONY: clean

deps/events.d:
	@echo "Compiling deps/events.d"
	git submodule update --init deps/events.d
	mkdir -p out
	mkdir -p out/di
	DEBUG=${DEBUG} $(MAKE) -C deps/events.d clean
	DEBUG=${DEBUG} $(MAKE) -C deps/events.d
	cp deps/events.d/out/events.d.a out/
	cp -r deps/events.d/out/events/* out/di

clean:
	rm -rf out/*
	rm -rf deps/*

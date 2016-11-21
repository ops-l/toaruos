CC=i686-pc-toaru-gcc
AR=i686-pc-toaru-ar

.PHONY: all go
all: ld.so libdemo.so demo

ld.so: linker.c link.ld
	i686-pc-toaru-gcc -std=c99 -o ld.so -Os -T link.ld linker.c

demo: demo.c
	i686-pc-toaru-gcc -o demo demo.c -L. -ldemo

libdemo.so: libdemo.c
	i686-pc-toaru-gcc -shared -fPIC -Wl,-soname,libdemo.so -o libdemo.so libdemo.c

libc.so:
	cp ${TOARU_SYSROOT}/usr/lib/libc.a libc.a
	# init and fini don't belong in our shared object
	${AR} d libc.a lib_a-init.o
	${AR} d libc.a lib_a-fini.o
	# Kill reentrant make crap
	${AR} d libc.a lib_a-calloc.o
	${AR} d libc.a lib_a-callocr.o
	${AR} d libc.a lib_a-cfreer.o
	${AR} d libc.a lib_a-freer.o
	${AR} d libc.a lib_a-malignr.o
	${AR} d libc.a lib_a-mallinfor.o
	${AR} d libc.a lib_a-mallocr.o
	${AR} d libc.a lib_a-malloptr.o
	${AR} d libc.a lib_a-mallstatsr.o
	${AR} d libc.a lib_a-msizer.o
	${AR} d libc.a lib_a-pvallocr.o
	${AR} d libc.a lib_a-realloc.o
	${AR} d libc.a lib_a-reallocr.o
	${AR} d libc.a lib_a-vallocr.o
	${CC} -shared -o libc.so -Wl,--whole-archive libc.a -Wl,--no-whole-archive
	rm libc.a

go: all
	cp demo ../hdd/bin/ld-demo
	cp libdemo.so ../hdd/bin/libdemo.so
	cp libc.so ../hdd/bin/libc.so
	cp ld.so ../hdd/bin/ld.so

cd: go
	cd ..; make cdrom
	-VBoxManage controlvm "ToaruOS Live CD" poweroff
	sleep 0.2
	-VBoxManage startvm "ToaruOS Live CD"
	sleep 3
	-VBoxManage controlvm "ToaruOS Live CD" keyboardputscancode 1c 9c
	sleep 2
	-VBoxManage controlvm "ToaruOS Live CD" keyboardputscancode 38 3e be b8 1d 38 14 94 b8 9d
	sleep 0.5
	-VBoxManage controlvm "ToaruOS Live CD" keyboardputscancode 38 0f 8f b8
	sleep 0.2
	-VBoxManage controlvm "ToaruOS Live CD" keyboardputscancode 38 44 c4 b8



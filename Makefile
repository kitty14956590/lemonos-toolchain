ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif
DESTDIR := 

LIBC_PATH := lemonos-libc
LINKED_PATH := linked-lists

default: depends

clean:
	rm -rf $(LIBC_PATH) $(LINKED_PATH)

depends:
	if [ ! -d "./linked-lists" ]; then \
		git clone https://github.com/kitty14956590/linked-lists; \
	fi
	if [ ! -d "./lemonos-libc" ]; then \
		git clone https://github.com/kitty14956590/lemonos-libc; \
	fi

	cd linked-lists; \
	git pull; \
	make; \
	cd ..;

	cd lemonos-libc; \
	git pull; \
	make; \
	cd ..;

install: $(LIBC_PATH)/libc.a $(LIBC_PATH)/include/ $(LINKED_PATH)/linked.o
	install -d $(DESTDIR)$(PREFIX)/lib/i386-lemonos/
	install -d $(DESTDIR)$(PREFIX)/bin/

	install -m 655 $(LIBC_PATH)/libc.a $(DESTDIR)$(PREFIX)/lib/i386-lemonos/
	install -m 655 $(LIBC_PATH)/link.ld $(DESTDIR)$(PREFIX)/lib/i386-lemonos/
	cp -r $(LIBC_PATH)/include/ $(DESTDIR)$(PREFIX)/lib/i386-lemonos/
	chmod 775 $(DESTDIR)$(PREFIX)/lib/i386-lemonos/include/ -R

	install -m 655 $(LINKED_PATH)/linked.o $(DESTDIR)$(PREFIX)/lib/i386-lemonos/
	cp -r $(LINKED_PATH)/include/ $(DESTDIR)$(PREFIX)/lib/i386-lemonos/linked_include/
	chmod 775 $(DESTDIR)$(PREFIX)/lib/i386-lemonos/linked_include/ -R

	install -m 775 i386-gcc-lemonos $(DESTDIR)$(PREFIX)/bin/
	install -m 775 i386-ld-lemonos $(DESTDIR)$(PREFIX)/bin/

uninstall:
	rm -rf /usr/local/bin/i386-*-lemonos /usr/local/lib/i386-lemonos

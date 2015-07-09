DESTDIR = /usr

link:
	mkdir -p $(DESTDIR)/bin
	ln -sf $(CURDIR)/src/build-project       $(DESTDIR)/bin/
	ln -sf $(CURDIR)/src/build-server-daemon $(DESTDIR)/bin/
	ln -sf $(CURDIR)/src/build-supervisor    $(DESTDIR)/bin/

install:
	mkdir -p $(DESTDIR)/bin
	cp -af src/build-project $(DESTDIR)/bin/
	cp -af src/build-server-daemon $(DESTDIR)/bin/
	cp -af src/build-supervisor $(DESTDIR)/bin/
	mkdir -p $(DESTDIR)/share/doc/sibuserv
	cp -af changelog LICENSE README $(DESTDIR)/share/doc/sibuserv/

uninstall:
	rm -f  $(DESTDIR)/bin/build-project
	rm -f  $(DESTDIR)/bin/build-server-daemon
	rm -f  $(DESTDIR)/bin/build-supervisor
	rm -rf $(DESTDIR)/share/doc/sibuserv


DESTDIR = /usr

ANDROID_SDK_FILE = android-sdk_r24.3.3-linux.tgz

ifeq ($(shell uname -m), x86_64)
	ANDROID_NDK_FILE = android-ndk-r10e-linux-x86_64.bin
else
	ANDROID_NDK_FILE = android-ndk-r10e-linux-x86.bin
endif

ifeq ($(shell uname -m), x86_64)
	QTSDK_FILE = qt-unified-linux-x64-online.run
else
	QTSDK_FILE = qt-unified-linux-x86-online.run
endif

# http://developer.android.com/sdk/index.html#Other
# http://developer.android.com/ndk/downloads/index.html

QTSDK_URL       = http://download.qt.io/official_releases/online_installers/
ANDROID_SDK_URL = http://dl.google.com/android
ANDROID_NDK_URL = http://dl.google.com/android/ndk


download:
	mkdir -p $(CURDIR)/opt
	cd $(CURDIR)/opt && [ -d lxe ] || \
		git clone https://github.com/tehnick/lxe.git
	cd $(CURDIR)/opt && [ -d mxe ] || \
		git clone https://github.com/tehnick/mxe.git
	cd $(CURDIR)/opt && [ -e "$(QTSDK_FILE)" ] || \
		wget -c $(QTSDK_URL)/$(QTSDK_FILE)
	cd $(CURDIR)/opt && [ -e "$(ANDROID_SDK_FILE)" ] || \
		wget -c $(ANDROID_SDK_URL)/$(ANDROID_SDK_FILE)
	cd $(CURDIR)/opt && [ -e "$(ANDROID_NDK_FILE)" ] || \
		wget -c $(ANDROID_NDK_URL)/$(ANDROID_NDK_FILE)
	chmod uog+x $(CURDIR)/opt/$(QTSDK_FILE) \
		$(CURDIR)/opt/$(ANDROID_NDK_FILE)

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


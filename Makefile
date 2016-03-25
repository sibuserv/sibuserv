DESTDIR = /usr

ANDROID_SDK_FILE = android-sdk_r24.4.1-linux.tgz

ifeq ($(shell uname -m), x86_64)
	ANDROID_NDK_FILE = android-ndk-r10e-linux-x86_64.bin
	QTSDK_FILE = qt-unified-linux-x64-online.run
else
	ANDROID_NDK_FILE = android-ndk-r10e-linux-x86.bin
	QTSDK_FILE = qt-unified-linux-x86-online.run
endif

# https://developer.android.com/sdk/index.html#Other
# https://developer.android.com/ndk/downloads/index.html

QTSDK_URL       = https://download.qt.io/official_releases/online_installers/
ANDROID_SDK_URL = https://dl.google.com/android
ANDROID_NDK_URL = https://dl.google.com/android/ndk


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


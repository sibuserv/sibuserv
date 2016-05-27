DESTDIR = /usr

ANDROID_SDK_VERSION = r24.4.1
ANDROID_NDK_VERSION = r10e

QT_SERIES=5.6
QT_VERSION=5.6.0

# https://developer.android.com/sdk/index.html#Other
# https://developer.android.com/ndk/downloads/index.html
# https://download.qt.io/official_releases/qt/

ANDROID_SDK_FILE = android-sdk_$(ANDROID_SDK_VERSION)-linux.tgz
ANDROID_NDK_FILE = android-ndk-$(ANDROID_NDK_VERSION)-linux-x86_64.bin

ANDROID_SDK_URL = https://dl.google.com/android
ANDROID_NDK_URL = https://dl.google.com/android/ndk

QT_SDK_FOR_ANDROID_FILE      = qt-opensource-linux-x64-android-$(QT_VERSION).run
QT_SDK_ONLINE_INSTALLER_FILE = qt-unified-linux-x64-online.run

QT_SDK_FOR_ANDROID_URL      = https://download.qt.io/official_releases/qt/$(QT_SERIES)/$(QT_VERSION)/
QT_SDK_ONLINE_INSTALLER_URL = https://download.qt.io/official_releases/online_installers/

download:
ifneq ($(shell uname -m), x86_64)
	$(error Unfortunately, Google and Digia have decided to \
	        discontinue support of Android SDK, NDK and Qt SDK \
	        for 32-bit Linux based systems. \
	        So only x86_64 systems are supported now)
endif
	mkdir -p $(CURDIR)/opt
	cd $(CURDIR)/opt && [ -d lxe ] || \
		git clone https://github.com/tehnick/lxe.git
	cd $(CURDIR)/opt && [ -d mxe ] || \
		git clone https://github.com/tehnick/mxe.git
	cd $(CURDIR)/opt && [ -e "$(ANDROID_SDK_FILE)" ] || \
		wget -c $(ANDROID_SDK_URL)/$(ANDROID_SDK_FILE)
	cd $(CURDIR)/opt && [ -e "$(ANDROID_NDK_FILE)" ] || \
		wget -c $(ANDROID_NDK_URL)/$(ANDROID_NDK_FILE)
	cd $(CURDIR)/opt && [ -e "$(QT_SDK_FOR_ANDROID_FILE)" ] || \
		wget -c $(QT_SDK_FOR_ANDROID_URL)/$(QT_SDK_FOR_ANDROID_FILE)
	cd $(CURDIR)/opt && [ -e "$(QT_SDK_ONLINE_INSTALLER_FILE)" ] || \
		wget -c $(QT_SDK_ONLINE_INSTALLER_URL)/$(QT_SDK_ONLINE_INSTALLER_FILE)
	chmod uog+x $(CURDIR)/opt/$(ANDROID_NDK_FILE) \
		    $(CURDIR)/opt/$(QT_SDK_FOR_ANDROID_FILE) \
		    $(CURDIR)/opt/$(QT_SDK_ONLINE_INSTALLER_FILE)

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


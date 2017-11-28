DESTDIR = /usr
DOWNLOADER = wget
UNZIP = unzip
GIT = git

ANDROID_SDK_VERSION = r25.2.5
ANDROID_NDK_VERSION = r16

ANDROID_SDK_CHECKSUM = 577516819c8b5fae680f049d39014ff1ba4af870b687cab10595783e6f22d33e
ANDROID_NDK_CHECKSUM = b7dcb08fa9fa403e3c0bc3f741a445d7f0399e93

QT_SERIES=5.9
QT_VERSION=5.9.3

# https://developer.android.com/studio/index.html#downloads
# https://developer.android.com/ndk/downloads/index.html
# https://download.qt.io/official_releases/qt/
# https://wiki.qt.io/Qt_for_Android_known_issues

ANDROID_SDK_FILE = tools_$(ANDROID_SDK_VERSION)-linux.zip
ANDROID_NDK_FILE = android-ndk-$(ANDROID_NDK_VERSION)-linux-x86_64.zip

ANDROID_SDK_URL = https://dl.google.com/android/repository
ANDROID_NDK_URL = https://dl.google.com/android/repository

QT_SDK_FOR_ANDROID_FILE      = qt-opensource-linux-x64-$(QT_VERSION).run
QT_SDK_ONLINE_INSTALLER_FILE = qt-unified-linux-x64-online.run

QT_SDK_FOR_ANDROID_URL      = https://download.qt.io/official_releases/qt/$(QT_SERIES)/$(QT_VERSION)
QT_SDK_ONLINE_INSTALLER_URL = https://download.qt.io/official_releases/online_installers

download: check-system linux windows android qt-sdk-online

prepare-dir:
	mkdir -p $(CURDIR)/opt

check-system:
ifneq ($(shell uname -m), x86_64)
	$(error Unfortunately, Google and Digia have decided to \
	        discontinue support of Android SDK, NDK and Qt SDK \
	        for 32-bit Linux based systems. \
	        So only x86_64 systems are supported now)
endif

linux: prepare-dir
	cd $(CURDIR)/opt && [ -d lxe ] || \
		$(GIT) clone https://github.com/sibuserv/lxe.git

windows: prepare-dir
	cd $(CURDIR)/opt && [ -d mxe ] || \
		$(GIT) clone https://github.com/sibuserv/mxe.git

android: prepare-dir
	cd $(CURDIR)/opt && [ -e "$(ANDROID_SDK_FILE)" ] || \
		$(DOWNLOADER) $(ANDROID_SDK_URL)/$(ANDROID_SDK_FILE)
	cd $(CURDIR)/opt && [ -e "$(ANDROID_NDK_FILE)" ] || \
		$(DOWNLOADER) $(ANDROID_NDK_URL)/$(ANDROID_NDK_FILE)
	cd $(CURDIR)/opt && [ -d "android-sdk-linux" ] || \
		$(UNZIP) $(ANDROID_SDK_FILE) -d "android-sdk-linux" > /dev/null
	cd $(CURDIR)/opt && [ -d "android-ndk-$(ANDROID_NDK_VERSION)" ] || \
		$(UNZIP) "$(ANDROID_NDK_FILE)" > /dev/null

qt-sdk-online: prepare-dir
	cd $(CURDIR)/opt && [ -e "$(QT_SDK_ONLINE_INSTALLER_FILE)" ] || \
		$(DOWNLOADER) $(QT_SDK_ONLINE_INSTALLER_URL)/$(QT_SDK_ONLINE_INSTALLER_FILE)
	chmod uog+x $(CURDIR)/opt/$(QT_SDK_ONLINE_INSTALLER_FILE)

qt-sdk-offline: prepare-dir
	cd $(CURDIR)/opt && [ -e "$(QT_SDK_FOR_ANDROID_FILE)" ] || \
		$(DOWNLOADER) $(QT_SDK_FOR_ANDROID_URL)/$(QT_SDK_FOR_ANDROID_FILE)
	chmod uog+x $(CURDIR)/opt/$(QT_SDK_FOR_ANDROID_FILE)

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


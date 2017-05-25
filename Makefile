DESTDIR = /usr
DOWNLOADER = wget
UNZIP = unzip
GIT = git

ANDROID_SDK_VERSION = 3859397
ANDROID_NDK_VERSION = r14b

ANDROID_SDK_CHECKSUM = 444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0
ANDROID_NDK_CHECKSUM = becd161da6ed9a823e25be5c02955d9cbca1dbeb

QT_SERIES=5.8
QT_VERSION=5.8.0

# https://developer.android.com/studio/index.html#downloads
# https://developer.android.com/ndk/downloads/index.html
# https://download.qt.io/official_releases/qt/

ANDROID_SDK_FILE = sdk-tools-linux-$(ANDROID_SDK_VERSION).zip
ANDROID_NDK_FILE = android-ndk-$(ANDROID_NDK_VERSION)-linux-x86_64.zip

ANDROID_SDK_URL = https://dl.google.com/android/repository/
ANDROID_NDK_URL = https://dl.google.com/android/repository/

QT_SDK_FOR_ANDROID_FILE      = qt-opensource-linux-x64-android-$(QT_VERSION).run
QT_SDK_ONLINE_INSTALLER_FILE = qt-unified-linux-x64-online.run

QT_SDK_FOR_ANDROID_URL      = https://download.qt.io/official_releases/qt/$(QT_SERIES)/$(QT_VERSION)/
QT_SDK_ONLINE_INSTALLER_URL = https://download.qt.io/official_releases/online_installers/

download: check-system linux windows android

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

qt-sdk: prepare-dir
	cd $(CURDIR)/opt && [ -e "$(QT_SDK_FOR_ANDROID_FILE)" ] || \
		$(DOWNLOADER) $(QT_SDK_FOR_ANDROID_URL)/$(QT_SDK_FOR_ANDROID_FILE)
	cd $(CURDIR)/opt && [ -e "$(QT_SDK_ONLINE_INSTALLER_FILE)" ] || \
		$(DOWNLOADER) $(QT_SDK_ONLINE_INSTALLER_URL)/$(QT_SDK_ONLINE_INSTALLER_FILE)
	chmod uog+x $(CURDIR)/opt/$(QT_SDK_FOR_ANDROID_FILE) \
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


DESTDIR = /usr
DOWNLOADER = wget
GIT = git

QT_SERIES=5.11
QT_VERSION=5.11.1

QT_SDK_CHECKSUM = 9f13c6f346ac74de85ba01a5328a1e1c # MD5

# https://download.qt.io/official_releases/qt/
# https://wiki.qt.io/Qt_for_Android_known_issues

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
	cd $(CURDIR)/opt && [ -d aplump ] || \
		$(GIT) clone https://github.com/sibuserv/aplump.git

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


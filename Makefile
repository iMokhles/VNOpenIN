GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 192.168.0.15

ARCHS = armv7 armv7s arm64

TARGET = iphone:clang:latest:6.0

THEOS_BUILD_DIR = Packages


include theos/makefiles/common.mk

TWEAK_NAME = VNOpenIN
VNOpenIN_CFLAGS = -fobjc-arc
VNOpenIN_FILES = VNOpenIN.x $(wildcard *.m)
VNOpenIN_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts MediaPlayer ImageIO CoreMedia MessageUI AssetsLibrary Security LocalAuthentication CoreData WebKit CoreText AdSupport CoreTelephony EventKit EventKitUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Vine"

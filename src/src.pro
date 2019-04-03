TARGET = qshodan
QT += quick multimedia network
CONFIG += c++11 qzxing_qml qzxing_multimedia

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    api/shodan.cpp \
    api/endpoints/shodanrequest.cpp \
    api/endpoints/shodanip.cpp \
    api/endpoints/shodanhostsearch.cpp \
    favoritehosts.cpp \
    api/shodansettings.cpp

HEADERS += \
    api/shodan.h \
    api/endpoints/shodanrequest.h \
    api/endpoints/shodanip.h \
    api/endpoints/shodanhostsearch.h \
    favoritehosts.h \
    api/shodansettings.h

RESOURCES += qml.qrc \
    img.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/bin
else: unix:!android: target.path = /usr/bin
!isEmpty(target.path): INSTALLS += target

include($$PWD/../3rdparty/qzxing/src/QZXing.pri)
include($$PWD/../3rdparty/qml-ui-set/qml-ui-set.pri)
TEMPLATE = app

android {
    QT += androidextras
    DISTFILES += \
        android/AndroidManifest.xml

    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android

    ANDROID_EXTRA_LIBS += $$OUT_PWD/../openssl/libcrypto.so
    ANDROID_EXTRA_LIBS += $$OUT_PWD/../openssl/libssl.so
}

ios {
    QMAKE_INFO_PLIST = $$PWD/ios/Info.plist

    app_icons.files = $$PWD/ios/qshodan.png
    app_launch_screen.files = $$PWD/ios/LaunchScreen.xib
    QMAKE_BUNDLE_DATA += app_launch_screen app_icons
}

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
}

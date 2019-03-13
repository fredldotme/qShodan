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
    api/shodanlogin.cpp \
    api/endpoints/shodanrequest.cpp \
    api/endpoints/shodanhost.cpp

HEADERS += \
    api/shodan.h \
    api/shodanlogin.h \
    api/endpoints/shodanrequest.h \
    api/endpoints/shodanhost.h

RESOURCES += qml.qrc

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

DISTFILES += \
    android/AndroidManifest.xml

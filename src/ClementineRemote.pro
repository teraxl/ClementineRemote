QT += core network quick

CONFIG += c++17

DEFINES += __USE_PLAYLIST_PROXY_MODEL__

CONFIG(debug, debug|release) :{
    DEFINES += __DEBUG__
}

#For linux
linux {
    LIBS += -lprotobuf
}

macx{
    LIBS += -L$$PWD/../protobuf-3.13.0/lib/macx/ -lprotobuf

    INCLUDEPATH += $$PWD/../protobuf-3.13.0/src
    DEPENDPATH += $$PWD/../protobuf-3.13.0/src

    PRE_TARGETDEPS += $$PWD/../protobuf-3.13.0/lib/macx/libprotobuf.a
}

win32{
    LIBS += -L$$PWD/../protobuf-3.13.0/lib/win64/ -lprotobuf

    INCLUDEPATH += $$PWD/../protobuf-3.13.0/src
    DEPENDPATH += $$PWD/../protobuf-3.13.0/src
}

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# remove Connection Thread as Sockets are Async
# and thus the Models are modified in the GUI Thread (no synch issues)
# cf https://forum.qt.io/topic/120468/qabstractlistmodel-populated-in-a-worker-thread-not-the-gui-one
DEFINES  -= __USE_CONNECTION_THREAD__

SOURCES += \
        ClementineRemote.cpp \
        ConnectionWorker.cpp \
        PlayListModel.cpp \
        RemoteFileModel.cpp \
        main.cpp \
        player/RemoteFile.cpp \
        player/RemotePlaylist.cpp \
        player/RemoteSong.cpp \
        protobuf/remotecontrolmessages.pb.cc

RESOURCES += \
    qml/qml.qrc \
    data/data.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    ClementineRemote.h \
    ConnectionWorker.h \
    PlayListModel.h \
    RemoteFileModel.h \
    Singleton.h \
    player/RemoteFile.h \
    player/RemotePlaylist.h \
    player/RemoteSong.h \
    protobuf/remotecontrolmessages.pb.h

DISTFILES += \
    protobuf/remotecontrolmessages.proto


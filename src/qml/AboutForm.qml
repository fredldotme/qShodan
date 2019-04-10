import QtQuick 2.0
import QtQuick.Controls 2.2

Page {
    title: qsTr("About qShodan")
    Flickable {
        width: parent.width
        height: parent.height
        contentHeight: mainColumn.height
        ScrollBar.vertical: ScrollBar {}

        Column {
            id: mainColumn
            width: parent.width
            spacing: 8

            Image {
                source: "qrc:/qshodan.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 3
                height: width
                sourceSize.width: width
                sourceSize.height: height
            }
            Label {
                text: qsTr("qShodan")
                font.pixelSize: Qt.application.font.pixelSize * 2
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }
            Label {
                text: qsTr("A native, cross-platform shodan.io client")
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            }

            MenuSeparator {
                width: parent.width
            }

            Label {
                font.underline: true
                text: qsTr("Donate via PayPal")
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("http://paypal.me/beidl")
                    }
                }
            }

            MenuSeparator {
                width: parent.width
            }

            Label {
                font.underline: true
                text: qsTr("Source code on GitHub")
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("http://github.com/fredldotme/qShodan")
                    }
                }
            }
            Label {
                text: qsTr("Licensed under Apache 2.0")
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            }

            MenuSeparator {
                width: parent.width
            }

            Label {
                text: qsTr("QZXing (Apache 2.0)")
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            }
            Label {
                text: qsTr("QML-Ui-Set (LGPL v2.1)")
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            }
        }
    }
}

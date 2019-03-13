import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "qrc:/utils.js" as Utils
import "qrc:/qml-ui-set"

Page {
    id: pageRoot

    property var service : null
    onServiceChanged: {
        console.log("Service: " + JSON.stringify(service))
    }

    readonly property var serviceInfo : service ?
                                            Utils.getInfo(service) :
                                            null
    signal backRequested()

    header: ToolBar {
        background: Rectangle { color: "transparent" }
        ToolButton {
            text: "\u2190 back"
            onClicked: backRequested()
            font.pixelSize: Qt.application.font.pixelSize * 1.5
            padding: 10
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: mainColumn.height + mainColumn.anchors.margins
        ScrollBar.vertical: ScrollBar {}

        Column {
            id: mainColumn
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: 32
            }

            spacing: 8

            DetailItem {
                width: parent.width
                label: "Type:"
                value: serviceInfo ? serviceInfo.type : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: "Title:"
                value: serviceInfo ? serviceInfo.title : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: "Address:"
                value: serviceInfo ? serviceInfo.address : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: "Data:"
                value: serviceInfo ? serviceInfo.data : ""
                ratio: 0.3
            }
        }
    }
}

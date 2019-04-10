import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0
import "qrc:/qml-ui-set"

Page {
    readonly property bool hasServices :
        (shodanIpApi.services.data !== undefined &&
         shodanIpApi.services.data.length > 0)

    readonly property int numPorts :
        hasServices ? shodanIpApi.services.data.length : 0

    Label {
        width: parent.width
        height: parent.height
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        text: qsTr("No services found")
        font.pixelSize: Qt.application.font.pixelSize * 1.8
        wrapMode: Label.WrapAtWordBoundaryOrAnywhere
        visible: !hasServices
    }

    Flickable {
        anchors.fill: parent
        contentHeight: mainColumn.height + mainColumn.anchors.margins
        clip: true
        ScrollBar.vertical: ScrollBar {}
        visible: !fetchingDetails

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
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("Services")
                visible: hasServices
            }
            Repeater {
                width: parent.width
                model: shodanIpApi.services.data
                delegate: Column {
                    width: parent.width
                    DetailItem {
                        width: parent.width
                        ratio: 0.3
                        label: qsTr("Port:")
                        value: shodanIpApi.services.data[index].port
                    }
                    DetailItem {
                        width: parent.width
                        ratio: 0.3
                        label: qsTr("Transport:")
                        value: shodanIpApi.services.data[index].transport
                    }
                    DetailItem {
                        width: parent.width
                        ratio: 0.3
                        label: qsTr("Data:")
                        value: shodanIpApi.services.data[index].data
                    }
                }
            }
        }
    }
}

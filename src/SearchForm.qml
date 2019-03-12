import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    width: 400
    height: 600

    property ShodanHost shodanHost : null

    header: Label {
        color: "#2b2626"
        text: qsTr("Search")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ColumnLayout {
        id: mainContainer
        anchors.fill: parent
        RowLayout {
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignCenter
            TextField {
                id: searchField
                Layout.preferredWidth: (parent.width/3)*2
                Keys.onReturnPressed: {
                    shodanHost.search(searchField.text)
                }
            }
            Button {
                text: qsTr("Search")
                Layout.preferredWidth: (parent.width/3)
                onClicked: {
                    shodanHost.search(searchField.text)
                }
            }
        }

        ListView {
            Layout.preferredWidth: parent.width - 64
            Layout.preferredHeight: parent.height - 64
            clip: true

            id: foundHostsList
            model: shodanHost.hosts
            spacing: 10
            delegate: Column {
                property string service : foundHostsList.model[index].ip + ":" +
                                          foundHostsList.model[index].port
                Label {
                    text: foundHostsList.model[index].asn
                    font.pixelSize: Qt.application.font.pixelSize * 1.8
                }
                Label {
                    text: "ISP: " + foundHostsList.model[index].isp
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
                Label {
                    text: "Service: " + service
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
            }
        }
    }
    BusyIndicator {
        anchors.centerIn: mainContainer
        running: shodanHost.busy
    }
}

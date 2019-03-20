import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0
import "qrc:/utils.js" as Utils
import "qrc:/qml-ui-set"

Page {
    property ShodanHostSearch shodanHost : null
    property ShodanIp shodanIp : null

    signal detailsRequested(var service)

    header: Label {
        color: Material.accent
        text: qsTr("Search shodan.io")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ColumnLayout {
        id: mainContainer
        anchors.fill: parent

        RowLayout {
            width: parent.width
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            TextField {
                id: searchField
                focus: true
                Layout.preferredWidth: (parent.width/4)*3
                Keys.onReturnPressed: {
                    if (searchField.text.length > 0)
                        shodanHost.search(searchField.text)
                }
            }
            Button {
                text: qsTr("Search")
                //width: (parent.width/4)
                onClicked: {
                    if (searchField.text.length > 0)
                        shodanHost.search(searchField.text)
                }
            }
        }

        ListView {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height - 64
            clip: true
            ScrollBar.vertical: ScrollBar {}

            id: foundHostsList
            model: shodanHost.hosts
            spacing: 10

            delegate: MouseArea {
                id: entryMouseArea
                width: parent.width
                height: childrenRect.height
                enabled: !shodanHostApi.busy

                onClicked: {
                    detailsRequested(shodanHost.hosts[index])
                }

                Rectangle {
                    width: parent.width
                    height: childrenRect.height
                    color: entryMouseArea.pressed ?
                               Material.accent :
                               "transparent"

                    Column {
                        width: parent.width
                        height: implicitHeight

                        Label {
                            text: Utils.getTitle(foundHostsList.model[index])
                            font.pixelSize: Qt.application.font.pixelSize * 1.8
                        }
                        Label {
                            property string service : foundHostsList.model[index].ip_str + ":" +
                                                      foundHostsList.model[index].port

                            text: "Service: " + service
                            font.pixelSize: Qt.application.font.pixelSize * 1.2
                        }
                        Label {
                            text: "ISP: " + foundHostsList.model[index].isp
                            font.pixelSize: Qt.application.font.pixelSize * 1.2
                        }
                    }
                }
            }
        }
    }
    AbortableBusyIndicator {
        anchors.centerIn: mainContainer
        running: shodanHost.busy
        onAbort: {
            shodanHostApi.reset()
        }
    }
}

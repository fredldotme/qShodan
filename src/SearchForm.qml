import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    width: 400
    height: 600

    property ShodanHost shodanHost : null
    signal detailsRequested(var service)

    header: Label {
        color: "#2b2626"
        text: qsTr("Search shodan.io")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ColumnLayout {
        id: mainContainer
        anchors.fill: parent
        RowLayout {
            width: parent.width - 64
            Layout.alignment: Qt.AlignCenter
            TextField {
                id: searchField
                width: (parent.width/3)*2
                Keys.onReturnPressed: {
                    shodanHost.search(searchField.text)
                }
            }
            Button {
                text: qsTr("Search")
                width: (parent.width/3)
                onClicked: {
                    shodanHost.search(searchField.text)
                }
            }
        }

        ListView {
            width: parent.width
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

                onClicked: {
                    detailsRequested(shodanHost.hosts[index])
                }

                Rectangle {
                    width: parent.width
                    height: childrenRect.height
                    color: entryMouseArea.pressed ?
                               "lightgray" :
                               "transparent"

                    Column {
                        width: parent.width
                        height: implicitHeight

                        Label {
                            function getTitle(obj) {
                                // HTTP(S)
                                if (obj.http !== undefined && obj.http !== null) {
                                    if (obj.http.title)
                                        return obj.http.title
                                }
                                // SSH
                                else if (obj.ssh !== undefined && obj.ssh !== null) {
                                    if (obj.ssh.fingerprint)
                                        return obj.ssh.fingerprint
                                }
                                // Print for adding support later on
                                else {
                                    console.log(JSON.stringify(obj))
                                }

                                return qsTr("Untitled")
                            }

                            text: getTitle(foundHostsList.model[index])
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
    BusyIndicator {
        anchors.centerIn: mainContainer
        running: shodanHost.busy
    }
}

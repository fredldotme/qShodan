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
            width: parent.width
            Layout.preferredHeight: parent.height - 64
            clip: true
            ScrollBar.vertical: ScrollBar {}

            id: foundHostsList
            model: shodanHost.hosts
            spacing: 10
            delegate: Column {
                width: parent.width
                height: implicitHeight

                Label {
                    function getTitle(obj) {
                        if (obj.http === undefined || obj.http === null)
                            return qsTr("Untitled")
                        else
                            return obj.http.title
                    }

                    text: getTitle(foundHostsList.model[index])
                    font.pixelSize: Qt.application.font.pixelSize * 1.8
                }
                Label {
                    property string service : foundHostsList.model[index].ip + ":" +
                                              foundHostsList.model[index].port

                    text: "Service: " + service
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
                Label {
                    text: "ISP: " + foundHostsList.model[index].isp
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
                MenuSeparator {
                    width: parent.width
                }
            }
        }
    }
    BusyIndicator {
        anchors.centerIn: mainContainer
        running: shodanHost.busy
    }
}

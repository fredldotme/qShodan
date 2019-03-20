import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    signal hostDetailsRequest(string ip)

    header: Label {
        text: qsTr("Favorites")
        color: Material.accent
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ListView {
        width: parent.width
        height: parent.height - 64
        clip: true
        ScrollBar.vertical: ScrollBar {}
        spacing: 10

        model: favorites.favorites
        delegate: MouseArea {
            id: entryMouseArea
            width: parent.width
            height: childrenRect.height
            onClicked: hostDetailsRequest(favorites.favorites[index].ip_str)

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: entryMouseArea.pressed ?
                           Material.accent :
                           "transparent"
                Label {
                    width: parent.width
                    text: favorites.favorites[index].ip_str
                    font.pixelSize: Qt.application.font.pixelSize * 1.8
                }
            }
        }
    }
}

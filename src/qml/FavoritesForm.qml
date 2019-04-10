import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    signal hostDetailsRequest(string ip)

    Label {
        width: parent.width
        anchors.centerIn: parent
        horizontalAlignment: Qt.AlignHCenter
        font.pixelSize: Qt.application.font.pixelSize * 1.8
        visible: favorites.favorites.length < 1
        text: qsTr("No favorites saved yet")
    }

    Dialog {
        id: renameDialog
        title: qsTr("Rename favorite:")
        standardButtons: Dialog.Ok
        modal: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: parent.width / 2
        onVisibleChanged: inputArea.forceActiveFocus()
        readonly property alias inputArea : inputArea

        TextInput {
            id: inputArea
            anchors.fill: parent
            width: parent.width
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
        }
        onAccepted: {
            favorites.rename(listView.selectedIp, inputArea.text)
            inputArea.text = ""
        }
    }

    ListView {
        id: listView
        width: parent.width
        height: parent.height - 64
        clip: true
        ScrollBar.vertical: ScrollBar {}
        spacing: 10

        property string selectedIp : ""

        model: favorites.favorites

        delegate: MouseArea {
            id: entryMouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            width: parent.width
            height: childrenRect.height

            Menu {
                id: contextMenu
                MenuItem {
                    text: qsTr("Rename")
                    onClicked: {
                        renameDialog.inputArea.text = favorites.favorites[index].name
                        renameDialog.open()
                    }
                }
            }

            function showContextMenu(x, y) {
                listView.selectedIp = favorites.favorites[index].ip_str
                contextMenu.parent = entryMouseArea
                contextMenu.x = x
                contextMenu.y = y
                contextMenu.open()
            }

            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    showContextMenu(mouseX, mouseY)
                    return;
                }

                hostDetailsRequest(favorites.favorites[index].ip_str)
            }
            onPressAndHold: {
                showContextMenu(mouseX, mouseY)
            }

            Rectangle {
                width: parent.width
                height: childrenRect.height
                color: entryMouseArea.pressed ?
                           Material.accent :
                           "transparent"
                Label {
                    width: parent.width
                    text: {
                        if (favorites.favorites[index].name === "") {
                            return favorites.favorites[index].ip_str
                        } else {
                            return favorites.favorites[index].name
                                    + " (%2)".arg(favorites.favorites[index].ip_str)
                        }
                    }
                    font.pixelSize: Qt.application.font.pixelSize * 1.8
                }
            }
        }
    }
}

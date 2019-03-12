import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

Page {
    width: 400
    height: 400

    signal clearApiKey()

    header: Label {
        color: "#2b2626"
        text: qsTr("Settings")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ColumnLayout {
        anchors.fill: parent
        Button {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Clear API key")
            onClicked: clearApiKey()
        }
    }
}

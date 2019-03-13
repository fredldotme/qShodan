import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

Page {
    property var service : null
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
}

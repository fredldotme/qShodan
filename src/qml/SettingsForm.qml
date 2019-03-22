import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    width: 400
    height: 400

    signal clearApiKey()

    property ShodanSettings settings : null

    header: Label {
        color: Material.accent
        text: qsTr("Settings")
        font.pixelSize: Qt.application.font.pixelSize * 2
        padding: 10
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        CheckBox {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Dark mode")
            checked: settings.darkMode
            onCheckedChanged: {
                settings.darkMode = checked
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Clear API key")
            onClicked: clearApiKey()
        }
    }
}

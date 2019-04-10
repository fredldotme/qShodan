import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0
import "qrc:/qml-ui-set"

Page {
    readonly property bool hasVulnerabilities :
        (shodanIpApi.services.vulns !== undefined &&
         shodanIpApi.services.vulns.length > 0)
    readonly property int numVulns :
        hasVulnerabilities ? shodanIpApi.services.vulns.length :
                             0

    Label {
        width: parent.width
        height: parent.height
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        text: qsTr("No vulnerable CVEs found")
        font.pixelSize: Qt.application.font.pixelSize * 1.8
        wrapMode: Label.WrapAtWordBoundaryOrAnywhere
        visible: !hasVulnerabilities
    }

    ListView {
        width: parent.width
        height: parent.height
        model: shodanIpApi.services.vulns
        spacing: 8
        clip: true
        delegate: Column {
            width: parent.width
            Label {
                width: parent.width
                text: shodanIpApi.services.vulns[index]
                font.underline: true
                horizontalAlignment: Label.AlignHCenter
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                color: mouseArea.pressed ?
                           Material.accent :
                           Material.foreground

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("https://cve.mitre.org/cgi-bin/"+
                                             "cvename.cgi?name=" +
                                             shodanIpApi.services.vulns[index])
                    }
                }
            }
        }
    }
}

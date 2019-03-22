import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0
import "qrc:/utils.js" as Utils
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

    Flickable {
        anchors.fill: parent
        contentHeight: mainColumn.height + mainColumn.anchors.margins
        clip: true
        ScrollBar.vertical: ScrollBar {}
        visible: !fetchingDetails

        Column {
            id: mainColumn
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: 32
            }

            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("CVEs:")
                visible: hasVulnerabilities
            }

            Repeater {
                width: parent.width
                model: shodanIpApi.services.vulns
                delegate: Column {
                    width: parent.width
                    Label {
                        width: parent.width
                        text: shodanIpApi.services.vulns[index]
                        font.underline: true
                        horizontalAlignment: Label.AlignHCenter
                        font.pixelSize: Qt.application.font.pixelSize * 1.5

                        MouseArea {
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
    }
}

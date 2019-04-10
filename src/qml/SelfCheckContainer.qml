import QtQuick 2.0
import QtQuick.Controls 2.0

Page {
    readonly property alias selfCheckContainerContainer : selfCheckContainerContainer
    title: qsTr("Self-check")

    Timer {
        id: ipQueryDelayTimer
        interval: 1000
        onTriggered: {
            shodanTools.ip()
        }
    }

    Connections {
        target: shodanTools
        onIpAddressChanged: {
            if (shodanTools.ipAddress === "")
                return

            var host = {
                "ip_str" : shodanTools.ipAddress
            }
            detailsForm.setHost(host)
        }
    }

    SwipeView {
        id: selfCheckContainerContainer
        anchors.fill: parent
        interactive: false

        Page {
            Column {
                anchors.centerIn: parent
                Label {
                    text: qsTr("Self-check allows you to do a checkup of your edge network "+
                               "devices via your current public facing IP address.")
                    width: selfCheckContainerContainer.width
                    font.pixelSize: Qt.application.font.pixelSize * 1.5
                    wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Qt.AlignHCenter
                }
                Button {
                    text: qsTr("Quick check")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        ipQueryDelayTimer.start()
                        selfCheckContainerContainer.currentIndex = 1
                    }
                }
            }
        }

        DetailsForm {
            id: detailsForm
            onBackRequested: {
                selfCheckContainerContainer.currentIndex = 0
                detailsForm.setHost(null)
            }
        }
    }
}

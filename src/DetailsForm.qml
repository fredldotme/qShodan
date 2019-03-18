import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import "qrc:/utils.js" as Utils
import "qrc:/qml-ui-set"

Page {
    id: pageRoot

    property var service : null
    readonly property var serviceInfo : service ?
                                            Utils.getInfo(service) :
                                            null
    readonly property bool fetchingDetails : serviceDetailsTimer.running || shodanIpApi.busy

    onServiceChanged: {
        // Load remaining services provided by the host
        // via the ShodanIp API
        if (!service)
            return
        serviceDetailsTimer.start()
    }
    onBackRequested: {
        serviceDetailsTimer.stop()
    }

    // Due to rate limits on the API endpoints
    // it's advisable to use a timer for delayed
    // requests
    Timer {
        id: serviceDetailsTimer
        interval: 1000
        repeat: false
        onTriggered: shodanIpApi.ip(service.ip_str)
    }

    signal backRequested()

    header: ToolBar {
        background: Rectangle { color: "transparent" }
        padding: 10
        width: parent.width
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "\u2190 back"
                onClicked: backRequested()
                font.pixelSize: Qt.application.font.pixelSize * 1.5
            }
            Label {
                text: serviceInfo ? serviceInfo.title : ""
                elide: Label.ElideRight
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            BusyIndicator {
                running: fetchingDetails
            }
            ToolButton {
                text: qsTr("Open")
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                onClicked: {
                    Qt.openUrlExternally("https://www.shodan.io/host/" + service.ip_str)
                }
            }
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: mainColumn.height + mainColumn.anchors.margins
        clip: true
        ScrollBar.vertical: ScrollBar {}

        Column {
            id: mainColumn
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: 32
            }

            spacing: 8

            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("Details:")
            }
            DetailItem {
                width: parent.width
                label: qsTr("Type:")
                value: serviceInfo ? serviceInfo.type : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: qsTr("Title:")
                value: serviceInfo ? serviceInfo.title : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: qsTr("Organisation:")
                value: serviceInfo ? serviceInfo.org : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: qsTr("Address:")
                value: serviceInfo ? serviceInfo.address : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: qsTr("Data:")
                value: serviceInfo ? serviceInfo.data : ""
                ratio: 0.3
            }

            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("Location:")
            }
            DetailItem {
                width: parent.width
                label: "Country:"
                value: serviceInfo ? serviceInfo.location.country_code : ""
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: qsTr("City:")
                value: serviceInfo ? serviceInfo.location.city : ""
                ratio: 0.3
            }

            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("All services:")
                visible: shodanIpApi.services.data !== undefined ?
                             shodanIpApi.services.data.length > 0
                           : false
            }
            Repeater {
                width: parent.width
                model: shodanIpApi.services.data
                delegate: Column {
                    width: parent.width
                    DetailItem {
                        width: parent.width
                        ratio: 0.3
                        label: qsTr("Port:")
                        value: shodanIpApi.services.data[index].port
                    }
                }
            }

            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("CVEs:")
                visible: shodanIpApi.services.vulns !== undefined ?
                             shodanIpApi.services.vulns.length > 0 :
                             false
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

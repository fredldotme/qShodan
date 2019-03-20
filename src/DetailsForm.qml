import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0
import "qrc:/utils.js" as Utils
import "qrc:/qml-ui-set"

Page {
    id: pageRoot

    property var host : null

    property bool isInFavorites : false
    readonly property bool fetchingDetails : serviceDetailsTimer.running || shodanIpApi.busy

    readonly property string starFull : "\u2605"
    readonly property string starEmpty : "\u2606"

    function setHost(host) {
        pageRoot.host = host
    }

    onHostChanged: {
        // Load remaining services provided by the host
        // via the ShodanIp API
        if (!host)
            return
        isInFavorites = favorites.contains(host.ip_str);
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
        onTriggered: shodanIpApi.ip(host.ip_str)
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
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                text: {
                    if (!host) {
                        return starEmpty
                    }

                    if (isInFavorites) {
                        return starFull
                    } else {
                        return starEmpty
                    }
                }

                font.pixelSize: Qt.application.font.pixelSize * 1.5
                onClicked: {
                    if (!isInFavorites)
                        favorites.add(host.ip_str)
                    else
                        favorites.remove(host.ip_str)
                    isInFavorites = favorites.contains(host.ip_str);
                }
            }
            ToolButton {
                text: qsTr("Open")
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                onClicked: {
                    Qt.openUrlExternally("https://www.shodan.io/host/" + host.ip_str)
                }
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: fetchingDetails
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

            spacing: 8

            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("Details")
            }
            DetailItem {
                width: parent.width
                label: qsTr("Organisation:")
                value: {
                    if (shodanIpApi.services.org !== undefined &&
                            shodanIpApi.services.org !== null) {
                        return shodanIpApi.services.org
                    } else {
                        return ""
                    }
                }
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: qsTr("Address:")
                value: host ? host.ip_str : ""
                ratio: 0.3
            }

            MenuSeparator {
                width: parent.width
            }
            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("Location")
            }
            DetailItem {
                width: parent.width
                label: "Country:"
                value: {
                    if (shodanIpApi.services.country_name !== undefined &&
                            shodanIpApi.services.country_name !== null) {
                        return shodanIpApi.services.country_name
                    } else {
                        return ""
                    }
                }
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: "Area:"
                value: {
                    if (shodanIpApi.services.area_code !== undefined &&
                            shodanIpApi.services.area_code !== null) {
                        return shodanIpApi.services.area_code
                    } else {
                        return ""
                    }
                }
                ratio: 0.3
            }
            DetailItem {
                width: parent.width
                label: qsTr("City:")
                value: {
                    if (shodanIpApi.services.city !== undefined &&
                            shodanIpApi.services.city !== null) {
                        return shodanIpApi.services.city
                    } else {
                        return ""
                    }
                }
                ratio: 0.3
            }

            MenuSeparator {
                width: parent.width
            }
            DetailItem {
                width: parent.width
                labelFont.pixelSize: Qt.application.font.pixelSize * 1.5
                ratio: 0.3
                label: qsTr("Services")
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
                    DetailItem {
                        width: parent.width
                        ratio: 0.3
                        label: qsTr("Transport:")
                        value: shodanIpApi.services.data[index].transport
                    }
                    DetailItem {
                        width: parent.width
                        ratio: 0.3
                        label: qsTr("Data:")
                        value: shodanIpApi.services.data[index].data
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

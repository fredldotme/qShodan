import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0
import "qrc:/js/utils.js" as Utils
import "qrc:/qml-ui-set"
import "qrc:/qml/details"

Page {
    id: pageRoot

    property var host : null

    property bool isInFavorites : false
    readonly property bool fetchingDetails : host === null ||
                                             serviceDetailsTimer.running ||
                                             shodanIpApi.busy

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

    // Due to rate limits on the API endpoints
    // it's advisable to use a timer for delayed
    // requests
    Timer {
        id: serviceDetailsTimer
        interval: 1000
        repeat: false
        onTriggered: shodanIpApi.ip(host.ip_str)
    }

    Keys.onBackPressed: {
        backRequested()
    }

    signal backRequested()
    onBackRequested: {
        serviceDetailsTimer.stop()
        shodanIpApi.reset()
        detailSwipeView.currentIndex = 0
    }

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
                text: qsTr("View")
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                onClicked: {
                    Qt.openUrlExternally("https://www.shodan.io/host/" + host.ip_str)
                }
            }
        }
    }

    SwipeView {
        id: detailSwipeView
        anchors.fill: parent

        // Host details
        HostDetails {}

        // Service ports
        ServiceDetails {
            id: serviceDetails
        }

        // CVE list
        CveDetails {
            id: cveDetails
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: detailSwipeView.currentIndex
        TabButton {
            text: qsTr("Details")
            onClicked: detailSwipeView.currentIndex = 0
        }
        TabButton {
            text: qsTr("Services (%1)").arg(serviceDetails.numPorts)
            onClicked: detailSwipeView.currentIndex = 1
        }
        TabButton {
            text: qsTr("CVEs (%1)").arg(cveDetails.numVulns)
            onClicked: detailSwipeView.currentIndex = 2
        }
    }

    AbortableBusyIndicator {
        anchors.centerIn: parent
        running: fetchingDetails
        onAbort: {
            backRequested()
        }
    }
}

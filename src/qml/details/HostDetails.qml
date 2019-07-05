import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import QtLocation 5.3
import me.fredl.shodan 1.0
import "qrc:/qml-ui-set"

Page {
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

            Plugin {
                id: mapPlugin
                locales: ["en_US"]
                preferred: ["osm"]
            }

            Map {
                readonly property int rectLength : Math.min(parent.width, parent.height)
                id: map
                anchors.horizontalCenter: parent.horizontalCenter
                width: rectLength / 2
                height: width

                plugin: mapPlugin
                zoomLevel: (maximumZoomLevel - minimumZoomLevel) / 1.5
                center {
                    latitude: {
                        if (shodanIpApi.services.latitude !== undefined &&
                                shodanIpApi.services.latitude !== null) {
                            return shodanIpApi.services.latitude
                        } else {
                            return 0.0
                        }
                    }
                    longitude: {
                        if (shodanIpApi.services.longitude !== undefined &&
                                shodanIpApi.services.longitude !== null) {
                            return shodanIpApi.services.longitude
                        } else {
                            return 0.0
                        }
                    }
                }

                property double zoomStep: (maximumZoomLevel - minimumZoomLevel) / 20

                Behavior on zoomLevel {
                    NumberAnimation {
                        duration: 200
                    }
                }
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
        }
    }
}

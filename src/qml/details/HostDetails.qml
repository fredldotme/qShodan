import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0
import "qrc:/utils.js" as Utils
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

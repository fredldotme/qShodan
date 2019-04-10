import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    property alias searchContainer : searchContainer
    title: qsTr("Search Shodan.io")

    SwipeView {
        id: searchContainer
        anchors.fill: parent
        interactive: false

        SearchForm {
            shodanHost: shodanHostApi
            shodanIp: shodanIpApi
            onDetailsRequested: {
                detailsForm.setHost(service)
                searchContainer.currentIndex = 1
            }
        }
        DetailsForm {
            id: detailsForm
            onBackRequested: {
                searchContainer.currentIndex = 0
                detailsForm.setHost(null)
            }
        }
    }
}

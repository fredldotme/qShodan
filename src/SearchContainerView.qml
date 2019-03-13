import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    SwipeView {
        id: searchContainer
        anchors.fill: parent
        interactive: false

        SearchForm {
            shodanHost: shodanHostApi
            onDetailsRequested: {
                detailsForm.service = service
                searchContainer.currentIndex = 1
            }
        }
        DetailsForm {
            id: detailsForm
            onBackRequested: {
                searchContainer.currentIndex = 0
            }
        }
    }
}

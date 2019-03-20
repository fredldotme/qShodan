import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import me.fredl.shodan 1.0

Page {
    SwipeView {
        id: favoritesContainer
        anchors.fill: parent
        interactive: false

        FavoritesForm {
            onHostDetailsRequest: {
                var host = {
                    "ip_str" : ip
                }
                detailsForm.setHost(host)
                favoritesContainer.currentIndex = 1
            }
        }

        DetailsForm {
            id: detailsForm
            onBackRequested: {
                favoritesContainer.currentIndex = 0
                detailsForm.setHost(null)
            }
        }
    }
}

#include "shodanhostsearch.h"

#include <QNetworkReply>

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

const QString SHODAN_HOST_SEARCH_ENDPOINT =
        QStringLiteral("https://api.shodan.io/shodan/host/search?key=%1&");

ShodanHostSearch::ShodanHostSearch(QObject* parent) : ShodanRequest (parent)
{

}

QVariantList ShodanHostSearch::hosts()
{
    return this->m_hosts;
}

void ShodanHostSearch::search(QString query)
{
    QUrlQuery requestFields;
    requestFields.addQueryItem("query", query);
    this->makeRequest(SHODAN_HOST_SEARCH_ENDPOINT.arg(apiKey()), requestFields);
}

void ShodanHostSearch::responseReceivedHandler()
{
    qDebug() << Q_FUNC_INFO;

    const QJsonDocument jsonDoc = QJsonDocument::fromJson(this->data());
    const QJsonArray matches = jsonDoc.object().value("matches").toArray();

    QVariantList foundHosts;

    for (const QJsonValue match : matches) {
        const QJsonObject matchObject = match.toObject();

        QVariantMap host = matchObject.toVariantMap();
        foundHosts.append(host);
    }

    this->m_hosts = foundHosts;
    emit hostsChanged();
}

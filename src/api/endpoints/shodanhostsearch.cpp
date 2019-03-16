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
    QVariantList foundHosts;

    const QJsonDocument jsonDoc = QJsonDocument::fromJson(this->data());
    const QJsonObject jsonObject = jsonDoc.object();
    if (!jsonObject.contains(QStringLiteral("matches")))
        return;

    const QJsonArray matches = jsonObject.value("matches").toArray();

    for (const QJsonValue match : matches) {
        const QJsonObject matchObject = match.toObject();
        QVariantMap host = matchObject.toVariantMap();
        if (!host.contains(QStringLiteral("ip_str")))
            continue;
        if (!host.contains(QStringLiteral("port")))
            continue;
        if (!host.contains(QStringLiteral("isp")))
            continue;
        if (!host.contains(QStringLiteral("asn")))
            continue;

        foundHosts.append(host);
    }

    this->m_hosts = foundHosts;
    emit hostsChanged();
}

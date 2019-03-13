#include "shodanhost.h"

#include <QNetworkReply>

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

const QString SHODAN_HOST_SEARCH_ENDPOINT =
        QStringLiteral("https://api.shodan.io/shodan/host/search?key=%1&");

ShodanHost::ShodanHost(QObject* parent) : ShodanRequest (parent)
{

}

QVariantList ShodanHost::hosts()
{
    return this->m_hosts;
}

void ShodanHost::search(QString query)
{
    QUrlQuery requestFields;
    requestFields.addQueryItem("query", query);
    this->makeRequest(requestFields);
}

QString ShodanHost::apiEndpoint()
{
    return SHODAN_HOST_SEARCH_ENDPOINT.arg(apiKey());
}

void ShodanHost::responseReceivedHandler()
{
    qDebug() << Q_FUNC_INFO;

    if (!this->reply()) {
        qWarning() << "Reply is null..";
        return;
    }

    const QByteArray response = this->reply()->readAll();
    const QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
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

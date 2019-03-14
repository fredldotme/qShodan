#include "shodanip.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

const QString SHODAN_HOST_IP_ENDPOINT =
        QStringLiteral("https://api.shodan.io/shodan/host/%1?key=%2");

ShodanIp::ShodanIp(QObject *parent) : ShodanRequest (parent)
{

}

QVariantMap ShodanIp::services()
{
    return this->m_services;
}

void ShodanIp::ip(QString ipAddress)
{
    const QString fullQueryUrl = SHODAN_HOST_IP_ENDPOINT.arg(ipAddress, apiKey());
    this->makeRequest(fullQueryUrl, QUrlQuery());
}

void ShodanIp::responseReceivedHandler()
{
    const QJsonDocument jsonDoc = QJsonDocument::fromJson(this->data());
    this->m_services = jsonDoc.object().toVariantMap();

    qDebug() << "services:" << jsonDoc.object().value("data").toArray();

    emit servicesChanged();
}

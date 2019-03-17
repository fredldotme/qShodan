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
    this->m_services = QVariantMap();
    emit servicesChanged();
    const QString fullQueryUrl = SHODAN_HOST_IP_ENDPOINT.arg(ipAddress, apiKey());
    this->makeRequest(fullQueryUrl, QUrlQuery());
}

void ShodanIp::responseReceivedHandler()
{
    const QJsonDocument jsonDoc = QJsonDocument::fromJson(this->data());
    const QVariantMap foundServices = jsonDoc.object().toVariantMap();

    if (!foundServices.contains(QStringLiteral("ip")))
        return;
    if (!foundServices.contains(QStringLiteral("region_code")))
        return;
    if (!foundServices.contains(QStringLiteral("area_code")))
        return;
    if (!foundServices.contains(QStringLiteral("country_code")))
        return;
    if (!foundServices.contains(QStringLiteral("city")))
        return;

    this->m_services = foundServices;
    //qDebug() << "services:" << jsonDoc.object().value("data").toArray();

    emit servicesChanged();
}

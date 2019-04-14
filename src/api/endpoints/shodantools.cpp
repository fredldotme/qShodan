#include "shodantools.h"

#include <QJsonDocument>
#include <QJsonObject>

const QString SHODAN_TOOLS_IP_ENDPOINT =
        QStringLiteral("https://api.shodan.io/tools/myip?key=%1");

ShodanTools::ShodanTools(QObject *parent) : ShodanRequest(parent)
{

}

QString ShodanTools::ipAddress()
{
    return this->m_ipAddress;
}

void ShodanTools::ip()
{
    this->getRequest(SHODAN_TOOLS_IP_ENDPOINT.arg(apiKey()), QUrlQuery());
}

void ShodanTools::responseReceivedHandler(const uint httpStatus)
{
    Q_UNUSED(httpStatus);

    QString currentIp = QString::fromUtf8(this->data());
    this->m_ipAddress = currentIp.replace("\"", "");
    qDebug() << "public IP:" << m_ipAddress;
    emit ipAddressChanged();
}

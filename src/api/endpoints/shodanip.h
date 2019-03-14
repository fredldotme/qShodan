#ifndef SHODANIP_H
#define SHODANIP_H

#include "shodanrequest.h"

class ShodanIp : public ShodanRequest
{
    Q_OBJECT
public:
    Q_PROPERTY(QVariantMap services READ services NOTIFY servicesChanged)

    explicit ShodanIp(QObject *parent = nullptr);
    QVariantMap services();

protected:
    void responseReceivedHandler() Q_DECL_OVERRIDE;

private:
    QVariantMap m_services;

public slots:
    void ip(QString ipAddress);

signals:
    void servicesChanged();
};

#endif // SHODANIP_H

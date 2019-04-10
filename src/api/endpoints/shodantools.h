#ifndef SHODANTOOLS_H
#define SHODANTOOLS_H

#include "shodanrequest.h"

class ShodanTools : public ShodanRequest
{
    Q_OBJECT
public:
    Q_PROPERTY(QString ipAddress READ ipAddress NOTIFY ipAddressChanged)
    explicit ShodanTools(QObject *parent = nullptr);

    QString ipAddress();

protected:
    void responseReceivedHandler(const uint httpStatus) Q_DECL_OVERRIDE;

private:
    QString m_ipAddress;

public slots:
    void ip();

signals:
    void ipAddressChanged();

};

#endif // SHODANTOOLS_H

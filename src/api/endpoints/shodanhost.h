#ifndef SHODANHOST_H
#define SHODANHOST_H

#include "shodanrequest.h"
#include <QVariantList>

class ShodanHost : public ShodanRequest
{
    Q_OBJECT

public:
    Q_PROPERTY(QVariantList hosts READ hosts NOTIFY hostsChanged)

    explicit ShodanHost(QObject* parent = nullptr);
    QVariantList hosts();

public slots:
    void search(QString query);

protected:
    QString apiEndpoint() Q_DECL_OVERRIDE;
    void responseReceivedHandler() Q_DECL_OVERRIDE;

private:
    QVariantList m_hosts;

signals:
    void hostsChanged();
};

#endif // SHODANHOST_H

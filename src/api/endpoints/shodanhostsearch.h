#ifndef SHODANHOSTSEARCH_H
#define SHODANHOSTSEARCH_H

#include "shodanrequest.h"
#include <QVariantList>

class ShodanHostSearch : public ShodanRequest
{
    Q_OBJECT

public:
    Q_PROPERTY(QVariantList hosts READ hosts NOTIFY hostsChanged)

    explicit ShodanHostSearch(QObject* parent = nullptr);
    QVariantList hosts();

public slots:
    void search(QString query);

protected:
    void responseReceivedHandler() Q_DECL_OVERRIDE;

private:
    QVariantList m_hosts;

signals:
    void hostsChanged();
};

#endif // SHODANHOSTSEARCH_H

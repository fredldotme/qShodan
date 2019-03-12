#ifndef SHODAN_H
#define SHODAN_H

#include <QObject>

#include "shodanlogin.h"
#include "endpoints/shodanhost.h"

class Shodan : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(ShodanHost* host READ host FINAL)
    Q_PROPERTY(ShodanLogin* login READ shodanLogin WRITE setShodanLogin NOTIFY shodanLoginChanged)

    explicit Shodan(QObject *parent = nullptr,
                    ShodanLogin* login = nullptr);

    void setShodanLogin(ShodanLogin* login);
    ShodanLogin* shodanLogin();

public slots:
    ShodanHost* host();

private:
    ShodanLogin* m_login = nullptr;
    ShodanHost m_host;

signals:
    void shodanLoginChanged();
};

#endif // SHODAN_H

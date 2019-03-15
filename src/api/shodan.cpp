#include "shodan.h"

Shodan::Shodan(QObject *parent,
               ShodanSettings* login) : QObject(parent)
{
    connect(this, &Shodan::shodanLoginChanged, this, [=](){
        if (!this->m_login)
            return;

        this->m_host.setApiKey(this->m_login->apiKey());
    });

    setShodanLogin(login);
}

void Shodan::setShodanLogin(ShodanSettings *login)
{
    if (this->m_login == login)
        return;

    this->m_login = login;
    emit shodanLoginChanged();
}

ShodanSettings* Shodan::shodanLogin()
{
    return this->m_login;
}

ShodanHostSearch* Shodan::host()
{
    return &this->m_host;
}

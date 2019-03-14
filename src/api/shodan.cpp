#include "shodan.h"

Shodan::Shodan(QObject *parent,
               ShodanLogin* login) : QObject(parent)
{
    connect(this, &Shodan::shodanLoginChanged, this, [=](){
        if (!this->m_login)
            return;

        this->m_host.setApiKey(this->m_login->apiKey());
    });

    setShodanLogin(login);
}

void Shodan::setShodanLogin(ShodanLogin *login)
{
    if (this->m_login == login)
        return;

    this->m_login = login;
    emit shodanLoginChanged();
}

ShodanLogin* Shodan::shodanLogin()
{
    return this->m_login;
}

ShodanHostSearch* Shodan::host()
{
    return &this->m_host;
}

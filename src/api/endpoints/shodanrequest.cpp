#include "shodanrequest.h"

#include <QDebug>
#include <QNetworkReply>

ShodanRequest::ShodanRequest(QObject* parent) : QObject(parent)
{
}

void ShodanRequest::makeRequest(QUrlQuery urlQuery)
{
    if (this->m_reply)
        return;

    const QString url = apiEndpoint() + urlQuery.toString();
    qDebug() << "URL: " << url;

    this->m_reply = this->m_accessManager.get(QNetworkRequest(url));
    //connect(this->m_reply, &QNetworkReply::readyRead,
    //        this, &ShodanRequest::responseReceivedHandler);
    connect(this->m_reply, &QNetworkReply::readChannelFinished,
            this, [=](){
        responseReceivedHandler();
        this->m_reply = nullptr;
        refreshBusy();
        qDebug() << Q_FUNC_INFO << "cleared";
    });

    refreshBusy();
}

QNetworkAccessManager* ShodanRequest::accessManager()
{
    return &this->m_accessManager;
}

QNetworkReply* ShodanRequest::reply()
{
    return this->m_reply;
}

QString ShodanRequest::apiKey()
{
    return this->m_key;
}

void ShodanRequest::setApiKey(const QString& key)
{
    if (this->m_key == key)
        return;

    this->m_key = key;
    emit apiKeyChanged();
}

bool ShodanRequest::busy()
{
    return (this->m_reply != nullptr);
}

void ShodanRequest::refreshBusy()
{
    emit busyChanged();
}

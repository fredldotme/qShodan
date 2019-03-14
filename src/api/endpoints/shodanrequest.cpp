#include "shodanrequest.h"

#include <QDebug>
#include <QNetworkReply>

ShodanRequest::ShodanRequest(QObject* parent) : QObject(parent)
{
}

void ShodanRequest::makeRequest(const QString& apiEndpoint, const QUrlQuery&urlQuery)
{
    if (this->m_reply)
        return;

    const QString url = apiEndpoint + urlQuery.toString();
    qDebug() << "URL: " << url;

    this->m_data.clear();
    this->m_reply = this->m_accessManager.get(QNetworkRequest(url));
    connect(this->m_reply, &QNetworkReply::readyRead,
            this, &ShodanRequest::readReadyData);
    connect(this->m_reply, &QNetworkReply::sslErrors,
            this, [=](){
        emit error(900, QStringLiteral("SSL error occured."));
        reset();
        return;
    });
    connect(this->m_reply, &QNetworkReply::readChannelFinished,
            this, [=](){
        if (this->m_reply->error() != QNetworkReply::NoError) {
            emit error(static_cast<int>(this->m_reply->error()),
                       this->m_reply->errorString());
            reset();
            return;
        }

        responseReceivedHandler();
        reset();
        qDebug() << Q_FUNC_INFO << "cleared";
    });

    refreshBusy();
}

void ShodanRequest::reset()
{
    this->m_reply->deleteLater();
    this->m_reply = nullptr;
    this->m_data.clear();
    refreshBusy();
}

QNetworkAccessManager* ShodanRequest::accessManager()
{
    return &this->m_accessManager;
}

QString ShodanRequest::apiKey()
{
    return this->m_key;
}

QByteArray& ShodanRequest::data()
{
    return this->m_data;
}

void ShodanRequest::readReadyData()
{
    if (!this->m_reply)
        return;

    this->m_data += this->m_reply->readAll();
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

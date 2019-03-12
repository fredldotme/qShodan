#ifndef SHODANREQUEST_H
#define SHODANREQUEST_H

#include <QObject>
#include <QUrlQuery>
#include <QNetworkAccessManager>

class ShodanRequest : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged)
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)

    ShodanRequest(QObject* parent = nullptr);

    void makeRequest(QUrlQuery urlQuery);

    QString apiKey();
    void setApiKey(const QString& key);
    bool busy();
    void refreshBusy();

protected:
    QNetworkAccessManager* accessManager();
    QNetworkReply* reply();
    virtual QString apiEndpoint() { return QString(); }
    virtual void responseReceivedHandler() {}

private:
    QNetworkAccessManager m_accessManager;
    QString m_key;
    QNetworkReply* m_reply = nullptr;

signals:
    void apiKeyChanged();
    void busyChanged();
};

#endif // SHODANREQUEST_H

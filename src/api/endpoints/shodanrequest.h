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

    explicit ShodanRequest(QObject* parent = nullptr);

    void makeRequest(const QString& apiEndpoint, const QUrlQuery& urlQuery);

    QString apiKey();
    void setApiKey(const QString& key);
    bool busy();
    void refreshBusy();

public slots:
    void reset();

protected:
    QNetworkAccessManager* accessManager();
    QByteArray& data();
    virtual void responseReceivedHandler() {}

private:
    void readReadyData();

    QByteArray m_data;
    QNetworkAccessManager m_accessManager;
    QString m_key;
    QNetworkReply* m_reply = nullptr;

signals:
    void apiKeyChanged();
    void busyChanged();
    void error(const int error, const QString errorString);
};

#endif // SHODANREQUEST_H

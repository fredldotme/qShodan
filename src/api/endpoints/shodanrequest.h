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

    QString apiKey();
    void setApiKey(const QString& key);
    bool busy();
    void refreshBusy();

public slots:
    void reset();

protected:
    void getRequest(const QString& apiEndpoint,
                        const QUrlQuery& urlQuery);
    void putRequest(const QString& apiEndpoint,
                        const QUrlQuery& urlQuery,
                        const QByteArray& requestData);
    QNetworkAccessManager* accessManager();
    QByteArray& data();
    virtual void responseReceivedHandler(const uint httpStatus = 0) {
        Q_UNUSED(httpStatus)
    }

private:
    void prepareNetworkReply(QNetworkReply* reply);
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

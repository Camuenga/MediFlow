#ifndef MEDIFLOWAPI_H
#define MEDIFLOWAPI_H

#include <QObject>

#include <QtNetwork/QNetworkAccessManager>

class MediFlowApi : public QObject
{
    Q_OBJECT

public:
    explicit MediFlowApi(QObject* parent = nullptr);

    Q_INVOKABLE void sendMessage(const QString& message);

signals:
    void resultReceived(const QString& result);
    void errorOccurred(const QString& error);

private:
    QNetworkAccessManager manager;
};

#endif // MEDIFLOWAPI_H

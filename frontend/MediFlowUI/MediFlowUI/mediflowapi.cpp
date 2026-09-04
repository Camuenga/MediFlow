#include "mediflowapi.h"

#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>

MediFlowApi::MediFlowApi(QObject* parent)
    : QObject(parent)
{
}

void MediFlowApi::sendMessage(const QString& message)
{
    QNetworkRequest request(QUrl("http://localhost:8080/api/intake"));

    request.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    QJsonObject json;
    json["message"] = message;

    QNetworkReply* reply = manager.post(request,QJsonDocument(json).toJson() );

    connect(
        reply,
        &QNetworkReply::finished,
        this,
        [this, reply]()
        {
            const QByteArray response =
                reply->readAll();

            // ==========================================
            // SERVER RETURNED JSON
            // ==========================================

            if (!response.isEmpty())
            {
                emit resultReceived(
                    QString::fromUtf8(response)
                    );
            }
            else
            {
                // ==========================================
                // NETWORK ERROR
                // ==========================================

                if (reply->error() != QNetworkReply::NoError)
                {
                    emit errorOccurred(
                        reply->errorString()
                        );
                }
                else
                {
                    emit errorOccurred(
                        "Empty server response"
                        );
                }
            }

            reply->deleteLater();
        }
    );
}
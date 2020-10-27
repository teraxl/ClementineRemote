//========================================================================
//
// Copyright (C) 2020 Matthieu Bruel <Matthieu.Bruel@gmail.com>
//
// This file is a part of ClementineRemote : https://github.com/mbruel/ClementineRemote
//
// ClementineRemote is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; version 3.0 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// You should have received a copy of the GNU Lesser General Public
// License along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301,
// USA.
//
//========================================================================

#ifndef CONNECTIONWORKER_H
#define CONNECTIONWORKER_H
#include "protobuf/remotecontrolmessages.pb.h"

#include <QTcpSocket>
#include <QBuffer>
#include <QTimer>
class ClementineRemote;
class RemotePlaylist;

/*!
 * \brief manages all the network communications
 * so they can be moved to another thread ;)
 */
class ConnectionWorker : public QObject
{
    Q_OBJECT

private:

    ClementineRemote *_remote;

    bool _allow_downloads;
    bool _downloader;

    QTcpSocket *_socket;
    QTimer      _timeout;
    QString     _disconnectReason;
    bool        _reading_protobuf;
    quint32     _expected_length;
    QBuffer     _buffer;


    // server details
    QString _host;
    ushort  _port;
    int     _auth_code; //!< -1 <=> no pass

public:
    ConnectionWorker(ClementineRemote *remote, QObject *parent = nullptr);
    ~ConnectionWorker();

    inline const QString &disconnectReason() const;
    inline void setDisconnectReason(const QString &disconnectReason);

signals:
    void connectToServer(const QString &host, ushort port, int auth_code);
    void disconnectFromServer();


private slots:
    void onConnectToServer(const QString &host, ushort port, int auth_code);
    void onDisconnectFromServer();

    void onChangeToSong(int proxyRow);
    void onSetTrackPostion(qint32 newPos);
    void onSetVolume(qint32 vol);

    void onNextSong();
    void onPreviousSong();
    void onSetEngineState(qint32 state);
    void onShuffle(ushort mode);
    void onRepeat(ushort mode);

    void onChangePlaylist(qint32 pIdx);




// Socket handlers
    void onConnected();
    void onDisconnected();
    void onReadyRead();
    void onSocketTimeout();
    void onError(QAbstractSocket::SocketError err);


private:
    // Sends data to client without check if authenticated
    void sendDataToServer(pb::remote::Message &msg);

    void _doChangeSong(int songIndex, qint32 playlistID);
};

const QString &ConnectionWorker::disconnectReason() const { return _disconnectReason; }
void ConnectionWorker::setDisconnectReason(const QString &disconnectReason) { _disconnectReason = disconnectReason; }

#endif // CONNECTIONWORKER_H
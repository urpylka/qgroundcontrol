/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#ifndef VideoSettings_H
#define VideoSettings_H

#include "SettingsGroup.h"

class VideoSettings : public SettingsGroup
{
    Q_OBJECT

public:
    VideoSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(videoSource)
    DEFINE_SETTINGFACT(udpPort)
    DEFINE_SETTINGFACT(tcpUrl)
    DEFINE_SETTINGFACT(rtspUrl)
    DEFINE_SETTINGFACT(aspectRatio)
    DEFINE_SETTINGFACT(videoFit)
    DEFINE_SETTINGFACT(gridLines)
    DEFINE_SETTINGFACT(showRecControl)
    DEFINE_SETTINGFACT(recordingFormat)
    DEFINE_SETTINGFACT(maxVideoSize)
    DEFINE_SETTINGFACT(enableStorageLimit)
    DEFINE_SETTINGFACT(rtspTimeout)
    DEFINE_SETTINGFACT(streamEnabled)
    DEFINE_SETTINGFACT(disableWhenDisarmed)

    DEFINE_SETTINGFACT(csVehicleID)
    DEFINE_SETTINGFACT(csVideoSource)
    DEFINE_SETTINGFACT(csUdpPort)
    DEFINE_SETTINGFACT(csTcpUrl)
    DEFINE_SETTINGFACT(csRtspUrl)
    DEFINE_SETTINGFACT(csAspectRatio)
    DEFINE_SETTINGFACT(csVideoFit)
    DEFINE_SETTINGFACT(csGridLines)
    DEFINE_SETTINGFACT(csShowRecControl)
    DEFINE_SETTINGFACT(csRecordingFormat)
    DEFINE_SETTINGFACT(csMaxVideoSize)
    DEFINE_SETTINGFACT(csEnableStorageLimit)
    DEFINE_SETTINGFACT(csRtspTimeout)
    DEFINE_SETTINGFACT(csStreamEnabled)

    Q_PROPERTY(bool     streamConfigured        READ streamConfigured       NOTIFY streamConfiguredChanged)
    Q_PROPERTY(bool     csStreamConfigured      READ csStreamConfigured     NOTIFY csStreamConfiguredChanged)
    Q_PROPERTY(QString  rtspVideoSource         READ rtspVideoSource        CONSTANT)
    Q_PROPERTY(QString  udp264VideoSource       READ udp264VideoSource      CONSTANT)
    Q_PROPERTY(QString  udp265VideoSource       READ udp265VideoSource      CONSTANT)
    Q_PROPERTY(QString  tcpVideoSource          READ tcpVideoSource         CONSTANT)
    Q_PROPERTY(QString  mpegtsVideoSource       READ mpegtsVideoSource      CONSTANT)

    bool     streamConfigured       ();
    bool     csStreamConfigured     ();
    QString  rtspVideoSource        () { return videoSourceRTSP; }
    QString  udp264VideoSource      () { return videoSourceUDPH264; }
    QString  udp265VideoSource      () { return videoSourceUDPH265; }
    QString  tcpVideoSource         () { return videoSourceTCP; }
    QString  mpegtsVideoSource      () { return videoSourceMPEGTS; }

    static const char* videoSourceNoVideo;
    static const char* videoDisabled;
    static const char* videoSourceUDPH264;
    static const char* videoSourceUDPH265;
    static const char* videoSourceRTSP;
    static const char* videoSourceTCP;
    static const char* videoSourceMPEGTS;

signals:
    void streamConfiguredChanged    ();
    void csStreamConfiguredChanged  ();

private slots:
    void _configChanged             (QVariant value);
    void _csConfigChanged           (QVariant value);

private:
    void _setDefaults               ();

private:
    bool _noVideo = false;

};

#endif

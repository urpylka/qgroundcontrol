#ifndef CHARGINGSTATIONFIRMWAREPLUGIN_H
#define CHARGINGSTATIONFIRMWAREPLUGIN_H

#include "FirmwarePlugin.h"

#define CUSTOM_MODE_UNKNOWN 0
#define CUSTOM_MODE_OPEN 1
#define CUSTOM_MODE_OPENING 2
#define CUSTOM_MODE_CLOSED 3
#define CUSTOM_MODE_CLOSING 4

class ChargingStationFactGroup : public FactGroup
{
    Q_OBJECT

public:
    ChargingStationFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* rtkSurveyIn        READ rtkSurveyIn        CONSTANT)

    Fact* rtkSurveyIn(void) { return &_rtkSurveyInFact; }

    static const char* _rtkSurveyInFactName;

    static const char* _settingsGroup;

private:
    Fact        _rtkSurveyInFact;
};

class ChargingStationFirmwarePlugin : public FirmwarePlugin
{
    Q_OBJECT

public:
    ChargingStationFirmwarePlugin(void);

    QString vehicleImageOpaque(const Vehicle* vehicle) const override;
    QString vehicleImageOutline(const Vehicle* vehicle) const override;
    bool isCapable(const Vehicle *vehicle, FirmwareCapabilities capabilities) override;
    QStringList flightModes(Vehicle* vehicle) override;
    bool setFlightMode(const QString& flightMode, uint8_t* base_mode, uint32_t* custom_mode) override;
    QString flightMode(uint8_t base_mode, uint32_t custom_mode) const override;
    const QVariantList& toolBarIndicators(const Vehicle* vehicle) override;
    void addMetaDataToFact(QObject* parameterMetaData, Fact* fact, MAV_TYPE vehicleType) override;
    FactMetaData* getMetaDataForFact(QObject* parameterMetaData, const QString& name, MAV_TYPE vehicleType) override;
    QString internalParameterMetaDataFile(Vehicle* vehicle) override { Q_UNUSED(vehicle); return QString(":/FirmwarePlugin/ChargingStation/ChargingStationParameterFactMetaData.xml"); }
    void getParameterMetaDataVersionInfo(const QString& metaDataFile, int& majorVersion, int& minorVersion) override;
    QObject* loadParameterMetaData(const QString& metaDataFile) final;
    QString getVersionParam(void) override { return QString("SYS_PARAM_VER"); }
    QString brandImageIndoor(const Vehicle* vehicle) const override { Q_UNUSED(vehicle); return QStringLiteral("/qmlimages/ChargingStation/BrandImage"); }
    QString brandImageOutdoor(const Vehicle* vehicle) const override { Q_UNUSED(vehicle); return QStringLiteral("/qmlimages/ChargingStation/BrandImage"); }

    virtual QMap<QString, FactGroup*>* factGroups(void) final;
    bool  adjustIncomingMavlinkMessage(Vehicle* vehicle, mavlink_message_t* message) final;
private:
    void _handleNamedValueInt(mavlink_message_t* message);
    void _handleMavlinkMessage(mavlink_message_t* message);

    QVariantList _toolBarIndicatorList;

    ChargingStationFactGroup _rtkFactGroup;
    QMap<QString, FactGroup*> _nameToFactGroupMap;
};

#endif

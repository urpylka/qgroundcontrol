#include "PX4ParameterMetaData.h"

#include "ChargingStationFirmwarePlugin.h"

ChargingStationFirmwarePlugin::ChargingStationFirmwarePlugin(void):
    _rtkFactGroup(this)
{
    _nameToFactGroupMap.insert("Charging Station", &_rtkFactGroup);
}

QString ChargingStationFirmwarePlugin::vehicleImageOpaque(const Vehicle* vehicle) const
{
    Q_UNUSED(vehicle);
    return QStringLiteral("/qmlimages/ChargingStation.svg");
}

QString ChargingStationFirmwarePlugin::vehicleImageOutline(const Vehicle* vehicle) const
{
    Q_UNUSED(vehicle);
    return QStringLiteral("/qmlimages/ChargingStation.svg");
}

bool ChargingStationFirmwarePlugin::isCapable(const Vehicle *vehicle, FirmwareCapabilities capabilities)
{
    Q_UNUSED(vehicle);
    return capabilities & SetFlightModeCapability;
}

QStringList ChargingStationFirmwarePlugin::flightModes(Vehicle* vehicle)
{
    Q_UNUSED(vehicle);

    QStringList flightModes;
    flightModes << tr("Open") << tr("Closed");
    return flightModes;
}

bool ChargingStationFirmwarePlugin::setFlightMode(const QString& flightMode, uint8_t* base_mode, uint32_t* custom_mode)
{
    *base_mode = MAV_MODE_FLAG_CUSTOM_MODE_ENABLED;

    if (flightMode.compare(tr("Open"), Qt::CaseInsensitive) == 0) {
        *custom_mode = CUSTOM_MODE_OPEN;
    } else if (flightMode.compare(tr("Closed"), Qt::CaseInsensitive) == 0) {
        *custom_mode = CUSTOM_MODE_CLOSED;
    } else {
        return false;
    }

    return true;
}

QString ChargingStationFirmwarePlugin::flightMode(uint8_t base_mode, uint32_t custom_mode) const
{
    if (base_mode & MAV_MODE_FLAG_CUSTOM_MODE_ENABLED) {
        switch (custom_mode) {
        case CUSTOM_MODE_OPEN:
            return tr("Open");
        case CUSTOM_MODE_OPENING:
            return tr("Opening");
        case CUSTOM_MODE_CLOSED:
            return tr("Closed");
        case CUSTOM_MODE_CLOSING:
            return tr("Closing");
        }
    } else {
        qWarning() << "Charging station mode without custom mode enabled";
    }

    return tr("Unknown");
}

const QVariantList& ChargingStationFirmwarePlugin::toolBarIndicators(const Vehicle* vehicle)
{
    Q_UNUSED(vehicle);

    if(_toolBarIndicatorList.size() == 0) {
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/MessageIndicator.qml")));
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/GPSIndicator.qml")));
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/BatteryIndicator.qml")));
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/ModeIndicator.qml")));
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/GPSRTKIndicator.qml")));
    }
    return _toolBarIndicatorList;
}

FactMetaData* ChargingStationFirmwarePlugin::getMetaDataForFact(QObject* parameterMetaData, const QString& name, MAV_TYPE vehicleType)
{
    PX4ParameterMetaData* px4MetaData = qobject_cast<PX4ParameterMetaData*>(parameterMetaData);

    if (px4MetaData) {
        return px4MetaData->getMetaDataForFact(name, vehicleType);
    } else {
        qWarning() << "Internal error: pointer passed to PX4FirmwarePlugin::getMetaDataForFact not PX4ParameterMetaData";
    }

    return NULL;
}

void ChargingStationFirmwarePlugin::addMetaDataToFact(QObject* parameterMetaData, Fact* fact, MAV_TYPE vehicleType)
{
    PX4ParameterMetaData* px4MetaData = qobject_cast<PX4ParameterMetaData*>(parameterMetaData);

    if (px4MetaData) {
        px4MetaData->addMetaDataToFact(fact, vehicleType);
    } else {
        qWarning() << "Internal error: pointer passed to PX4FirmwarePlugin::addMetaDataToFact not PX4ParameterMetaData";
    }
}

void ChargingStationFirmwarePlugin::getParameterMetaDataVersionInfo(const QString& metaDataFile, int& majorVersion, int& minorVersion)
{
    return PX4ParameterMetaData::getParameterMetaDataVersionInfo(metaDataFile, majorVersion, minorVersion);
}

QObject* ChargingStationFirmwarePlugin::loadParameterMetaData(const QString& metaDataFile)
{
    PX4ParameterMetaData* metaData = new PX4ParameterMetaData;
    if (!metaDataFile.isEmpty()) {
        metaData->loadParameterFactMetaDataFile(metaDataFile);
    }
    return metaData;
}

void ChargingStationFirmwarePlugin::_handleNamedValueInt(mavlink_message_t* message)
{
    mavlink_named_value_int_t namedValueInt;
    mavlink_msg_named_value_int_decode(message, &namedValueInt);

    if (QString(namedValueInt.name) == "rtk_survey")
        _rtkFactGroup.rtkSurveyIn()->setRawValue(namedValueInt.value + 1) ;
}

void ChargingStationFirmwarePlugin::_handleMavlinkMessage(mavlink_message_t* message)
{
    switch (message->msgid) {
    // Charging station RTK Survey In status message
    case MAVLINK_MSG_ID_NAMED_VALUE_INT:
        _handleNamedValueInt(message);
        break;
    }
}

QMap<QString, FactGroup*>* ChargingStationFirmwarePlugin::factGroups(void) {
    return &_nameToFactGroupMap;
}

bool ChargingStationFirmwarePlugin::adjustIncomingMavlinkMessage(Vehicle* vehicle, mavlink_message_t* message)
{
    _handleMavlinkMessage(message);
    return true;
}

const char* ChargingStationFactGroup::_rtkSurveyInFactName = "rtkSurveyIn";

ChargingStationFactGroup::ChargingStationFactGroup(QObject* parent):
    FactGroup(1000, ":/json/Vehicle/ChargingStationFact.json", parent),
    _rtkSurveyInFact(0, _rtkSurveyInFactName, FactMetaData::valueTypeInt32)
{
    _addFact(&_rtkSurveyInFact, _rtkSurveyInFactName);
}

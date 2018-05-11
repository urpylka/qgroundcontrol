#include "ChargingStationFirmwarePlugin.h"

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
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/ModeIndicator.qml")));
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/GPSRTKIndicator.qml")));
    }
    return _toolBarIndicatorList;
}

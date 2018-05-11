#include "ChargingStationFirmwarePluginFactory.h"

ChargingStationFirmwarePluginFactory ChargingStationFirmwarePluginFactory;

QList<MAV_AUTOPILOT> ChargingStationFirmwarePluginFactory::supportedFirmwareTypes(void) const
{
    QList<MAV_AUTOPILOT> list;

    list.append(MAV_AUTOPILOT_GENERIC);
    return list;
}

QList<MAV_TYPE> ChargingStationFirmwarePluginFactory::supportedVehicleTypes(void) const
{
    QList<MAV_TYPE> vehicleTypes;
    vehicleTypes << MAV_TYPE_CHARGING_STATION;
    return vehicleTypes;
}

FirmwarePlugin* ChargingStationFirmwarePluginFactory::firmwarePluginForAutopilot(MAV_AUTOPILOT autopilotType, MAV_TYPE vehicleType)
{
    Q_UNUSED(autopilotType);

    if (vehicleType == MAV_TYPE_CHARGING_STATION) {
        if (!_pluginInstance) {
            _pluginInstance = new ChargingStationFirmwarePlugin;
        }
        return _pluginInstance;
    }

    return NULL;
}

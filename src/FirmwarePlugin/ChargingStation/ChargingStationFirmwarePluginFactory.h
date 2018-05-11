#ifndef CHARGINGSTATIONFIRMWAREPLUGINFACTORY_H
#define CHARGINGSTATIONFIRMWAREPLUGINFACTORY_H

#include "FirmwarePlugin.h"
#include "ChargingStationFirmwarePlugin.h"

class ChargingStationFirmwarePluginFactory : public FirmwarePluginFactory
{
    Q_OBJECT

public:
    ChargingStationFirmwarePluginFactory(void)
        : _pluginInstance(NULL)
    { }

    QList<MAV_AUTOPILOT> supportedFirmwareTypes(void) const override;
    QList<MAV_TYPE> supportedVehicleTypes(void) const override;
    FirmwarePlugin* firmwarePluginForAutopilot(MAV_AUTOPILOT autopilotType, MAV_TYPE vehicleType) override;

private:
    ChargingStationFirmwarePlugin*  _pluginInstance;
};

#endif // CHARGINGSTATIONFIRMWAREPLUGINFACTORY_H

#ifndef CHARGINGSTATIONFIRMWAREPLUGIN_H
#define CHARGINGSTATIONFIRMWAREPLUGIN_H

#include "FirmwarePlugin.h"

#define CUSTOM_MODE_UNKNOWN 0
#define CUSTOM_MODE_OPEN 1
#define CUSTOM_MODE_OPENING 2
#define CUSTOM_MODE_CLOSED 3
#define CUSTOM_MODE_CLOSING 4

class ChargingStationFirmwarePlugin : public FirmwarePlugin
{
    Q_OBJECT

public:
    QString vehicleImageOpaque(const Vehicle* vehicle) const override;
    QString vehicleImageOutline(const Vehicle* vehicle) const override;
    bool isCapable(const Vehicle *vehicle, FirmwareCapabilities capabilities) override;
    QStringList flightModes(Vehicle* vehicle) override;
    bool setFlightMode(const QString& flightMode, uint8_t* base_mode, uint32_t* custom_mode) override;
    QString flightMode(uint8_t base_mode, uint32_t custom_mode) const override;
    const QVariantList& toolBarIndicators(const Vehicle* vehicle) override;

private:
    QVariantList _toolBarIndicatorList;
};

#endif

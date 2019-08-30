/****************************************************************************
 *
 *   (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


#ifndef RTKGPSComponent_H
#define RTKGPSComponent_H

#include "VehicleComponent.h"

/// @file
///     @brief GPS/RTK settings
///     @author Andrey Dvornikov <dvornikov-aa@yandex.ru>

class RTKGPSComponent : public VehicleComponent
{
    Q_OBJECT
    
public:
    RTKGPSComponent(Vehicle* vehicle, AutoPilotPlugin* autopilot, QObject* parent = NULL);
    
    // Overrides from VehicleComponent
    QStringList setupCompleteChangedTriggerList(void) const override;

    // Overrides from VehicleComponent
    QString name                    (void) const override;
    QString description             (void) const override;
    QString iconResource            (void) const override;
    bool    requiresSetup           (void) const override;
    bool    setupComplete           (void) const override;
    QUrl    setupSource             (void) const override;
    QUrl    summaryQmlSource        (void) const override;
    bool    allowSetupWhileArmed    (void) const override { return true; }

private:
    const QString   _name;
    QVariantList    _summaryItems;
};

#endif

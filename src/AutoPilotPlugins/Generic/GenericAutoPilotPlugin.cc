/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/// @file
///     @author Don Gagne <don@thegagnes.com>

#include "GenericAutoPilotPlugin.h"

GenericAutoPilotPlugin::GenericAutoPilotPlugin(Vehicle* vehicle, QObject* parent) :
    AutoPilotPlugin(vehicle, parent),
    _RTKGPSComponent(NULL)
{
    if (!vehicle) {
        qWarning() << "Internal error";
    }
}

const QVariantList& GenericAutoPilotPlugin::vehicleComponents(void)
{
    if (_components.count() == 0) {
        if (_vehicle) {
            _RTKGPSComponent = new RTKGPSComponent(_vehicle, this);
            _RTKGPSComponent->setupTriggerSignals();
            _components.append(QVariant::fromValue((VehicleComponent*)_RTKGPSComponent));
        } else {
            qWarning() << "Internal error";
        }
    }

    return _components;
}

QString GenericAutoPilotPlugin:: prerequisiteSetup(VehicleComponent* component) const
{
    Q_UNUSED(component);
    return QString();
}

/****************************************************************************
 *
 *   (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/// @file
///     @author Andrey Dvornikov <dvornikov-aa@yandex.ru>

#include "RTKGPSComponent.h"
#include "GenericAutoPilotPlugin.h"

RTKGPSComponent::RTKGPSComponent(Vehicle* vehicle, AutoPilotPlugin* autopilot, QObject* parent) :
    VehicleComponent(vehicle, autopilot, parent),
    _name(tr("RTK GPS"))
{
}

QString RTKGPSComponent::name(void) const
{
    return _name;
}

QString RTKGPSComponent::description(void) const
{
    return tr("RTK GPS module setup.");
}

QString RTKGPSComponent::iconResource(void) const
{
    return "/qmlimages/Gps.svg";
}

bool RTKGPSComponent::requiresSetup(void) const
{
    return true;
}

bool RTKGPSComponent::setupComplete(void) const
{
    return true;
}

QStringList RTKGPSComponent::setupCompleteChangedTriggerList(void) const
{
    return QStringList();
}

QUrl RTKGPSComponent::setupSource(void) const
{
    return QUrl::fromUserInput("qrc:/qml/RTKGPSComponent.qml");
}

QUrl RTKGPSComponent::summaryQmlSource(void) const
{
    return QUrl();
}

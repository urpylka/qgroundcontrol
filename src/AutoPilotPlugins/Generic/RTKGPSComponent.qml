/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0

SetupPage {
    id:             rtkGpsPage
    pageComponent:  pageComponent

    Component {
        id: pageComponent

        Item {
            width:  Math.max(availableWidth, innerColumn.width)
            height: innerColumn.height

            ColumnLayout {
                id:                         innerColumn
                spacing:                    ScreenTools.defaultFontPixelHeight

                QGCButton {
                    text:               qsTr("Restart Survey In")
                    Layout.columnSpan:  3
                    Layout.alignment:   Qt.AlignHCenter

                    onClicked: surveyInRestartWarning.open()
                }

                MessageDialog {
                    id: surveyInRestartWarning
                    title: "Survey In restart"
                    text: "Survey In procedure may take a long time. Continue?"
                    standardButtons: StandardButton.Yes | StandardButton.No
                    onYes: {
                        var activeVehicle = QGroundControl.multiVehicleManager.activeVehicle
                        // Send MAV_CMD_USER_1 (31010) to MAV_COMP_ID_AUTOPILOT1 (1)
                        activeVehicle.sendCommand(1, 31010, true)
                    }
                }
            } // Column
        } // Item
    } // Component
} // SetupPage

import QtQuick          2.3
import QtQuick.Layouts  1.2
import QtQuick.Dialogs  1.3

import QGroundControl                       1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0

SetupPage {
    id:            metaDataUpdatePage
    pageComponent: metaDataUpdatePageComponent
    pageName:      "Metadata" // For building setup page title: 'Meta Setup'

    Component {
        id: metaDataUpdatePageComponent
        Column {
            id:         parametersMetaColumn
            width:      SetupPage.width
            spacing:    ScreenTools.defaultFontPixelHeight / 2

            QGCLabel {
                id:     parameterMetaDataLabel
                text:   qsTr("Parameters Metadata Settings")
            }

            Rectangle {
                height: 1
                width:  parameterMetaDataLabel.width
                color:  qgcPal.button
            }

            Row {
                spacing:    ScreenTools.defaultFontPixelWidth
                QGCButton {
                    text:               qsTr("Update...")
                    Layout.columnSpan:  3
                    Layout.alignment:   Qt.AlignHCenter

                    onClicked:  {
                        parametersMetaDataFileDialog.openForLoad()
                    }
                }

                QGCFileDialog {
                   id: parametersMetaDataFileDialog
                   title: "Select metadata for parameters..."
                   selectExisting: true
                   fileExtension: "xml"

                   onAcceptedForLoad: {
                        var activeVehicle = QGroundControl.multiVehicleManager.activeVehicle
                        var result = activeVehicle.parameterManager.updateMetaDataFile(file)

                        if (result.length !== 0)
                            showMessage(qsTr("Parameters metadata update failed"), result, StandardButton.Ok)
                        else
                            showMessage(qsTr("Parameters metadata updated"),
                                        qsTr("Reconnect to the vehicle to apply new metadata"), StandardButton.Ok)
                    }
                }
            }
        }
    }
} // metaDataUpdatePage

/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.Palette           1.0
import QGroundControl.Vehicle           1.0
import QGroundControl.Controllers       1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0

/// Camera page for Instrument Panel PageView
Column {
    Component.onCompleted: activeVehicle.updateDuocamProperties()
    width:      pageWidth
    spacing:    ScreenTools.defaultFontPixelHeight * 0.25

    property bool   showSettingsIcon:       _camera !== null

    property var    _dynamicCameras:        activeVehicle ? activeVehicle.dynamicCameras : null
    property bool   _isCamera:              _dynamicCameras ? _dynamicCameras.cameras.count > 0 : false
    property var    _camera:                _isCamera ? (_dynamicCameras.cameras.get(_curCameraIndex) && _dynamicCameras.cameras.get(_curCameraIndex).paramComplete ? _dynamicCameras.cameras.get(_curCameraIndex) : null) : null
    property bool   _cameraModeUndefined:   _camera ? _dynamicCameras.cameras.get(_curCameraIndex).cameraMode === QGCCameraControl.CAMERA_MODE_UNDEFINED : true
    property bool   _cameraVideoMode:       _camera ? _dynamicCameras.cameras.get(_curCameraIndex).cameraMode === 1 : false
    property bool   _cameraPhotoMode:       _camera ? _dynamicCameras.cameras.get(_curCameraIndex).cameraMode === 0 : false
    property bool   _cameraPhotoIdle:       _camera && _camera.photoStatus === QGCCameraControl.PHOTO_CAPTURE_IDLE
    property bool   _cameraElapsedMode:     _camera && _camera.cameraMode === QGCCameraControl.CAM_MODE_PHOTO && _camera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE
    property real   _spacers:               ScreenTools.defaultFontPixelHeight * 0.5
    property real   _labelFieldWidth:       ScreenTools.defaultFontPixelWidth * 30
    property real   _editFieldWidth:        ScreenTools.defaultFontPixelWidth * 30
    property bool   _communicationLost:     activeVehicle ? activeVehicle.connectionLost : false
    property bool   _hasModes:              _camera && _camera && _camera.hasModes
    property bool   _videoRecording:        _camera && _camera.videoStatus === QGCCameraControl.VIDEO_CAPTURE_STATUS_RUNNING
    property bool   _storageReady:          _camera && _camera.storageStatus === QGCCameraControl.STORAGE_READY
    property bool   _storageIgnored:        _camera && _camera.storageStatus === QGCCameraControl.STORAGE_NOT_SUPPORTED
    property bool   _canShoot:              !_videoRecording && _cameraPhotoIdle && ((_storageReady && _camera.storageFree > 0) || _storageIgnored)
    property int    _curCameraIndex:        _dynamicCameras ? _dynamicCameras.currentCamera : 0

    function showSettings() {
        mainWindow.showComponentDialog(cameraSettings, _cameraVideoMode ? qsTr("Video Settings") : qsTr("Camera Settings"), 70, StandardButton.Ok)
    }

    //-- Dumb camera trigger if no actual camera interface exists
    QGCButton {
        anchors.horizontalCenter:   parent.horizontalCenter
        text:                       qsTr("Trigger Camera")
        visible:                    !_camera
        onClicked:                  activeVehicle.triggerCamera()
        enabled:                    activeVehicle
        objectName:                 "triggerCameraButton"
    }

    QGCButton {
        anchors.horizontalCenter:   parent.horizontalCenter
        text:                       qsTr("Refresh values")
        onClicked:                  activeVehicle.updateDuocamProperties()
        enabled:                    activeVehicle
    }

    Row {
        QGCLabel {
            text: "Thermal frame: "
        }

        CheckBox{
            id: showThermalFrame
            checked: activeVehicle._duocamShowThermal
            visible: !activeVehicle._duocamShowThermalUpdating
            onClicked: {
                if (checkedState == Qt.Checked)
                {
                    console.debug("Thermal frame, 1")
                    activeVehicle.setCameraProperty("showThermalFrame", 1)
                }
                else
                {
                    console.debug("Thermal frame, 0")
                    activeVehicle.setCameraProperty("showThermalFrame", 0)
                }
            }
        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamShowThermalUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

    Row {
        QGCLabel {
            text: "Visual frame: "
        }

        CheckBox{
            id: showVisualFrame
            checked: activeVehicle._duocamShowVisual
            visible: !activeVehicle._duocamShowVisualUpdating
            onClicked: {
                if (checkedState == Qt.Checked)
                {
                    console.debug("Visual frame, 1")
                    activeVehicle.setCameraProperty("showVisualFrame", 1)
                }
                else
                {
                    console.debug("Visual frame, 0")
                    activeVehicle.setCameraProperty("showVisualFrame", 0)
                }
            }
        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamShowVisualUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

    Row {
        QGCLabel {
            text: "Apply Sobel ED: "
        }

        CheckBox{
            id: applySobel
            checked: activeVehicle._duocamApplySobel
            visible: !activeVehicle._duocamApplySobelUpdating
            onClicked: {
                if (checkedState == Qt.Checked)
                {
                    console.debug("Apply sobel, 1")
                    activeVehicle.setCameraProperty("applySobel", 1)
                }
                else
                {
                    console.debug("Apply sobel, 0")
                    activeVehicle.setCameraProperty("applySobel", 0)
                }
            }
        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamApplySobelUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

    Row {
        QGCLabel {
            text: "Apply Canny ED: "
        }

        CheckBox{
            id: applyCanny
            checked: activeVehicle._duocamApplyCanny
            visible: !activeVehicle._duocamApplyCannyUpdating
            onClicked: {
                if (checkedState == Qt.Checked)
                {
                    console.debug("Apply Canny, 1")
                    activeVehicle.setCameraProperty("applyCanny", 1)
                }
                else
                {
                    console.debug("Apply Canny, 0")
                    activeVehicle.setCameraProperty("applyCanny", 0)
                }
            }
        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamApplyCannyUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

    Row {
        QGCLabel {
            text: "Apply colormap: "
        }

        CheckBox{
            id: applyColormap
            checked: activeVehicle._duocamApplyColormap
            visible: !activeVehicle._duocamApplyColormapUpdating
            onClicked: {
                if (checkedState == Qt.Checked)
                {
                    console.debug("Apply Colormap, 1")
                    activeVehicle.setCameraProperty("applyColormap", 1)
                }
                else
                {
                    console.debug("Apply Colormap, 0")
                    activeVehicle.setCameraProperty("applyColormap", 0)
                }
            }
        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamApplyColormapUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

    Row{
        visible: applyColormap.checked
        QGCLabel {
            text: qsTr("Colormap: ")
        }

        ComboBox {
            currentIndex: activeVehicle._duocamColormap
            visible: !activeVehicle._duocamColormapUpdating
            model: ListModel {
                id: cbColormap
                ListElement { text: "AUTUMN"; value: 0.0 }
                ListElement { text: "BONE"; value: 1.0 }
                ListElement { text: "JET"; value: 2.0 }
                ListElement { text: "WINTER"; value: 3.0 }
                ListElement { text: "RAINBOW"; value: 4.0 }
                ListElement { text: "OCEAN"; value: 5.0 }
                ListElement { text: "SUMMER"; value: 6.0 }
                ListElement { text: "SPRING"; value: 7.0 }
                ListElement { text: "COOL"; value: 8.0 }
                ListElement { text: "HSV"; value: 9.0 }
                ListElement { text: "PINK"; value: 10.0 }
                ListElement { text: "HOT"; value: 11.0 }
            }
            width: parent.width/2
            onCurrentIndexChanged: {
                console.debug(cbColormap.get(currentIndex).text + ", " + cbColormap.get(currentIndex).value)
                activeVehicle.setCameraProperty("colormap", cbColormap.get(currentIndex).value)
            }

        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamColormapUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

    Row {
        QGCLabel {
            text: "Show FPS: "
        }

        CheckBox{
            id: showFPS
            checked: activeVehicle._duocamShowFPS
            visible: !activeVehicle._duocamShowFPSUpdating
            onClicked: {
                if (checkedState == Qt.Checked)
                {
                    console.debug("show FPS, 1")
                    activeVehicle.setCameraProperty("showFPS", 1)
                }
                else
                {
                    console.debug("show FPS, 0")
                    activeVehicle.setCameraProperty("showFPS", 0)
                }
            }
        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamShowFPSUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

    Row {
        QGCLabel {
            text: "Show temperature: "
        }

        CheckBox{
            id: showTemperature
            checked: activeVehicle._duocamShowTemperature
            visible: !activeVehicle._duocamShowTemperatureUpdating
            onClicked: {
                if (checkedState == Qt.Checked)
                {
                    console.debug("show Temperature, 1")
                    activeVehicle.setCameraProperty("showTemperature", 1)
                }
                else
                {
                    console.debug("show Temperature, 0")
                    activeVehicle.setCameraProperty("showTemperature", 0)
                }
            }
        }

        QGCLabel {
            text: "|"
            visible: activeVehicle._duocamShowTemperatureUpdating
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
            }
        }
    }

//    Row{
//        QGCLabel {
//            text: "Color palette: "
//        }

//        ComboBox {
//            currentIndex: -1
//            model: ListModel {
//                id: cbColorPalette
//                ListElement { text: "Hot metal"; value: 0 }
//                ListElement { text: "White hot"; value: 1 }
//                ListElement { text: "Rainbow"; value: 2 }
//            }
//            width: parent.width/2
//            onCurrentIndexChanged: {
//                console.debug(cbColorPalette.get(currentIndex).text + ", " + cbColorPalette.get(currentIndex).value)
//                activeVehicle.setCameraProperty("colorPalette", cbColorPalette.get(currentIndex).value)
//            }
//        }
//    }

//    Row {
//        QGCLabel {
//            text: "Enable MSX: "
//        }

//        CheckBox{
//            id: enableMSX
//            onClicked: {
//                if (checkedState == Qt.Checked)
//                {
//                    console.debug("enableMSX, 1")
//                    activeVehicle.setCameraProperty("enableMSX", 1)
//                }
//                else
//                {
//                    console.debug("enableMSX, 0")
//                    activeVehicle.setCameraProperty("enableMSX", 0)
//                }
//            }
//        }
//    }

//    Row{
//        visible: enableMSX.checked
//        QGCLabel {
//            text: "MSX Strngth: "
//        }

//        Slider {
//            value: 50
//            stepSize: 1
//            maximumValue: 100
//            width: parent.width/2
//            onValueChanged: {
//                console.debug("MSX Strngth: " + value)
//                activeVehicle.setCameraProperty("strengthMSX", value)
//            }
//        }
//    }

    Item { width: 1; height: ScreenTools.defaultFontPixelHeight; visible: _camera; }
    //-- Actual controller
    QGCLabel {
        id:             cameraLabel
        text:           _camera ? _camera.modelName : qsTr("Camera")
        visible:        _camera
        font.pointSize: ScreenTools.smallFontPointSize
        anchors.horizontalCenter: parent.horizontalCenter
    }
    QGCLabel {
        text: _camera ? qsTr("Free Space: ") + _camera.storageFreeStr : ""
        font.pointSize: ScreenTools.smallFontPointSize
        anchors.horizontalCenter: parent.horizontalCenter
        visible: _camera && _storageReady
    }
    //-- Camera Mode (visible only if camera has modes)
    Item { width: 1; height: ScreenTools.defaultFontPixelHeight * 0.75; visible: camMode.visible; }
    Rectangle {
        id:         camMode
        width:      _hasModes ? ScreenTools.defaultFontPixelWidth * 8 : 0
        height:     _hasModes ? ScreenTools.defaultFontPixelWidth * 4 : 0
        color:      qgcPal.button
        radius:     height * 0.5
        visible:    _hasModes
        anchors.horizontalCenter: parent.horizontalCenter
        //-- Video Mode
        Rectangle {
            width:  parent.height
            height: parent.height
            color:  _cameraVideoMode ? qgcPal.window : qgcPal.button
            radius: height * 0.5
            anchors.left: parent.left
            border.color: qgcPal.text
            border.width: _cameraVideoMode ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            QGCColoredImage {
                height:             parent.height * 0.5
                width:              height
                anchors.centerIn:   parent
                source:             "/qmlimages/camera_video.svg"
                fillMode:           Image.PreserveAspectFit
                sourceSize.height:  height
                color:              _cameraVideoMode ? qgcPal.colorGreen : qgcPal.text
                MouseArea {
                    anchors.fill:   parent
                    enabled:        _cameraPhotoMode
                    onClicked: {
                        _camera.setVideoMode()
                    }
                }
            }
        }
        //-- Photo Mode
        Rectangle {
            width:  parent.height
            height: parent.height
            color:  _cameraPhotoMode ? qgcPal.window : qgcPal.button
            radius: height * 0.5
            anchors.right: parent.right
            border.color: qgcPal.text
            border.width: _cameraPhotoMode ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            QGCColoredImage {
                height:             parent.height * 0.5
                width:              height
                anchors.centerIn:   parent
                source:             "/qmlimages/camera_photo.svg"
                fillMode:           Image.PreserveAspectFit
                sourceSize.height:  height
                color:              _cameraPhotoMode ? qgcPal.colorGreen : qgcPal.text
                MouseArea {
                    anchors.fill:   parent
                    enabled:        _cameraVideoMode
                    onClicked: {
                        _camera.setPhotoMode()
                    }
                }
            }
        }
    }
    //-- Shutter
    Item { width: 1; height: ScreenTools.defaultFontPixelHeight * 0.75; visible: camShutter.visible; }
    Rectangle {
        id:         camShutter
        color:      Qt.rgba(0,0,0,0)
        width:      ScreenTools.defaultFontPixelWidth * 6
        height:     width
        radius:     width * 0.5
        visible:    _camera
        border.color: qgcPal.buttonText
        border.width: 3
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {
            width:      parent.width * (_videoRecording || (_cameraPhotoMode && !_cameraPhotoIdle && _cameraElapsedMode) ? 0.5 : 0.75)
            height:     width
            radius:     _videoRecording || (_cameraPhotoMode && !_cameraPhotoIdle && _cameraElapsedMode) ? 0 : width * 0.5
            color:      (_cameraModeUndefined || !_canShoot) ? qgcPal.colorGrey : qgcPal.colorRed
            anchors.centerIn:   parent
        }
        MouseArea {
            anchors.fill:   parent
            enabled:        !_cameraModeUndefined && _canShoot
            onClicked: {
                if(_cameraVideoMode) {
                    _camera.toggleVideo()
                } else {
                    if(_cameraPhotoMode && !_cameraPhotoIdle && _cameraElapsedMode) {
                        _camera.stopTakePhoto()
                    } else {
                        _camera.takePhoto()
                    }
                }
            }
        }
    }
    Item { width: 1; height: ScreenTools.defaultFontPixelHeight * 0.75; visible: _camera; }
    QGCLabel {
        text: (_cameraVideoMode && _camera.videoStatus === QGCCameraControl.VIDEO_CAPTURE_STATUS_RUNNING) ? _camera.recordTimeStr : "00:00:00"
        font.pointSize: ScreenTools.smallFontPointSize
        visible: _cameraVideoMode
        anchors.horizontalCenter: parent.horizontalCenter
    }
    QGCLabel {
        text: activeVehicle && _cameraPhotoMode ? ('00000' + activeVehicle.cameraTriggerPoints.count).slice(-5) : "00000"
        font.pointSize: ScreenTools.smallFontPointSize
        visible: _cameraPhotoMode
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Item { width: 1; height: ScreenTools.defaultFontPixelHeight; visible: _camera; }
    Component {
        id: cameraSettings
        QGCViewDialog {
            id: _cameraSettingsDialog
            QGCFlickable {
                anchors.fill:       parent
                contentHeight:      camSettingsCol.height
                flickableDirection: Flickable.VerticalFlick
                clip:               true
                Column {
                    id:             camSettingsCol
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    spacing:        _margins
                    //-------------------------------------------
                    //-- Camera Selector
                    Row {
                        spacing:            ScreenTools.defaultFontPixelWidth
                        visible:            _isCamera && _dynamicCameras.cameraLabels.length > 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCLabel {
                            text:           qsTr("Camera Selector:")
                            width:          _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCComboBox {
                            id:             cameraSelector
                            model:          _isCamera ? _dynamicCameras.cameraLabels : []
                            width:          _editFieldWidth
                            onActivated:    _dynamicCameras.currentCamera = index
                            currentIndex:   _dynamicCameras.currentCamera
                        }
                    }
                    //-------------------------------------------
                    //-- Stream Selector
                    Row {
                        spacing:            ScreenTools.defaultFontPixelWidth
                        visible:            _isCamera && _camera.streamLabels.length > 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCLabel {
                            text:           qsTr("Stream Selector:")
                            width:          _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCComboBox {
                            model:          _camera ? _camera.streamLabels : []
                            width:          _editFieldWidth
                            onActivated:    _camera.currentStream = index
                            currentIndex:   _camera ? _camera.currentStream : 0
                        }
                    }
                    //-------------------------------------------
                    //-- Thermal Modes
                    Row {
                        spacing:            ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible:            QGroundControl.videoManager.hasThermal
                        property var thermalModes: [qsTr("Off"), qsTr("Blend"), qsTr("Full"), qsTr("Picture In Picture")]
                        QGCLabel {
                            text:           qsTr("Thermal View Mode")
                            width:          _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCComboBox {
                            width:          _editFieldWidth
                            model:          parent.thermalModes
                            currentIndex:   _camera ? _camera.thermalMode : 0
                            onActivated:    _camera.thermalMode = index
                        }
                    }
                    //-------------------------------------------
                    //-- Thermal Video Opacity
                    Row {
                        spacing:            ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible:            QGroundControl.videoManager.hasThermal && _camera.thermalMode === QGCCameraControl.THERMAL_BLEND
                        QGCLabel {
                            text:           qsTr("Blend Opacity")
                            width:          _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Slider {
                            width:          _editFieldWidth
                            maximumValue:   100
                            minimumValue:   0
                            value:          _camera ? _camera.thermalOpacity : 0
                            updateValueWhileDragging: true
                            onValueChanged: {
                                _camera.thermalOpacity = value
                            }
                        }
                    }
                    //-------------------------------------------
                    //-- Camera Settings
                    Repeater {
                        model:      _camera ? _camera.activeSettings : []
                        Row {
                            spacing:        ScreenTools.defaultFontPixelWidth
                            anchors.horizontalCenter: parent.horizontalCenter
                            property var    _fact:      _camera.getFact(modelData)
                            property bool   _isBool:    _fact.typeIsBool
                            property bool   _isCombo:   !_isBool && _fact.enumStrings.length > 0
                            property bool   _isSlider:  _fact && !isNaN(_fact.increment)
                            property bool   _isEdit:    !_isBool && !_isSlider && _fact.enumStrings.length < 1
                            QGCLabel {
                                text:       parent._fact.shortDescription
                                width:      _labelFieldWidth
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            FactComboBox {
                                width:      parent._isCombo ? _editFieldWidth : 0
                                fact:       parent._fact
                                indexModel: false
                                visible:    parent._isCombo
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            FactTextField {
                                width:      parent._isEdit ? _editFieldWidth : 0
                                fact:       parent._fact
                                visible:    parent._isEdit
                            }
                            QGCSlider {
                                width:          parent._isSlider ? _editFieldWidth : 0
                                maximumValue:   parent._fact.max
                                minimumValue:   parent._fact.min
                                stepSize:       parent._fact.increment
                                visible:        parent._isSlider
                                updateValueWhileDragging:   false
                                anchors.verticalCenter:     parent.verticalCenter
                                Component.onCompleted: {
                                    value = parent._fact.value
                                }
                                onValueChanged: {
                                    parent._fact.value = value
                                }
                            }
                            Item {
                                width:      parent._isBool ? _editFieldWidth : 0
                                height:     factSwitch.height
                                visible:    parent._isBool
                                anchors.verticalCenter: parent.verticalCenter
                                property var _fact: parent._fact
                                Switch {
                                    id: factSwitch
                                    anchors.left:   parent.left
                                    checked:        parent._fact ? parent._fact.value : false
                                    onClicked:      parent._fact.value = checked ? 1 : 0
                                }
                            }
                        }
                    }
                    //-------------------------------------------
                    //-- Time Lapse
                    Row {
                        spacing:        ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible:        _cameraPhotoMode
                        property var photoModes: [qsTr("Single"), qsTr("Time Lapse")]
                        QGCLabel {
                            text:       qsTr("Photo Mode")
                            width:      _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCComboBox {
                            id:             photoModeCombo
                            width:          _editFieldWidth
                            model:          parent.photoModes
                            currentIndex:   _camera ? _camera.photoMode : 0
                            onActivated:    _camera.photoMode = index
                        }
                    }
                    //-------------------------------------------
                    //-- Time Lapse Interval
                    Row {
                        spacing:        ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible:        _cameraPhotoMode && _camera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE
                        QGCLabel {
                            text:       qsTr("Photo Interval (seconds)")
                            width:      _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Item {
                            height:     photoModeCombo.height
                            width:      _editFieldWidth
                            QGCSlider {
                                maximumValue:   60
                                minimumValue:   1
                                stepSize:       1
                                value:          _camera ? _camera.photoLapse : 5
                                displayValue:   true
                                updateValueWhileDragging: true
                                anchors.fill:   parent
                                onValueChanged: {
                                    _camera.photoLapse = value
                                }
                            }
                        }
                    }
                    //-------------------------------------------
                    // Grid Lines
                    Row {
                        visible:                _camera && _camera.autoStream
                        spacing:                ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCLabel {
                           text:                qsTr("Grid Lines")
                           width:               _labelFieldWidth
                           anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCSwitch {
                            enabled:            _streamingEnabled && activeVehicle
                            checked:            QGroundControl.settingsManager.videoSettings.gridLines.rawValue
                            width:              _editFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                if(checked) {
                                    QGroundControl.settingsManager.videoSettings.gridLines.rawValue = 1
                                } else {
                                    QGroundControl.settingsManager.videoSettings.gridLines.rawValue = 0
                                }
                            }
                        }
                    }
                    //-------------------------------------------
                    //-- Video Fit
                    Row {
                        visible:                _camera && _camera.autoStream
                        spacing:                ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCLabel {
                            text:               qsTr("Video Screen Fit")
                            width:               _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        FactComboBox {
                            fact:               QGroundControl.settingsManager.videoSettings.videoFit
                            indexModel:         false
                            width:              _editFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    //-------------------------------------------
                    //-- Reset Camera
                    Row {
                        spacing:                ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCLabel {
                            text:       qsTr("Reset Camera Defaults")
                            width:      _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCButton {
                            text:       qsTr("Reset")
                            onClicked:  resetPrompt.open()
                            width:      _editFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                            MessageDialog {
                                id:                 resetPrompt
                                title:              qsTr("Reset Camera to Factory Settings")
                                text:               qsTr("Confirm resetting all settings?")
                                standardButtons:    StandardButton.Yes | StandardButton.No
                                onNo: resetPrompt.close()
                                onYes: {
                                    _camera.resetSettings()
                                    resetPrompt.close()
                                }
                            }
                        }
                    }
                    //-------------------------------------------
                    //-- Format Storage
                    Row {
                        spacing:        ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        QGCLabel {
                            text:       qsTr("Storage")
                            width:      _labelFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCButton {
                            text:       qsTr("Format")
                            onClicked:  formatPrompt.open()
                            width:      _editFieldWidth
                            anchors.verticalCenter: parent.verticalCenter
                            MessageDialog {
                                id:                 formatPrompt
                                title:              qsTr("Format Camera Storage")
                                text:               qsTr("Confirm erasing all files?")
                                standardButtons:    StandardButton.Yes | StandardButton.No
                                onNo: formatPrompt.close()
                                onYes: {
                                    _camera.formatCard()
                                    formatPrompt.close()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//========================================================================
//
// Copyright (C) 2020 Matthieu Bruel <Matthieu.Bruel@gmail.com>
//
// This file is a part of ClementineRemote : https://github.com/mbruel/ClementineRemote
//
// ClementineRemote is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; version 3.0 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// You should have received a copy of the GNU Lesser General Public
// License along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301,
// USA.
//
//========================================================================

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    visible: true
    width: 400
    height: 600

    property string title: qsTr("no title...")

    property int toolBarIndex       : 0
    property int toolBarHeight      : 50
    property int toolBarSpacing     : 15
    property int toolBarMargin      : 20
    property int toolBarButtonWidth : 50

    property int headerButtonSize   : 30
    property int mainMargin         : 20

    property int trackLength: cppRemote.currentTrackLength()

    property color bgGradiantStart: "#8b008b" // darkmagenta (https://doc.qt.io/qt-5/qml-color.html)
    property color bgGradiantStop:  "#ff8c00" // darkorange


    // Menus
    ListModel {
        id: toolBarModel

        ListElement { name : "playlist" ; color: "white" }
        ListElement { name : "file"     ; color: "lightgray" }
        ListElement { name : "library"  ; color: "lightblue" }
        ListElement { name : "internet" ; color: "ivory" }
        ListElement { name : "search"   ; color: "lightgreen" }
    }


    // background
    Rectangle {
        id: background
        anchors {
            fill: parent;
            margins: 0;
        }
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: bgGradiantStart }
            GradientStop { position: 1.0; color: bgGradiantStop }
        }
        opacity: 0.8
    }


    // mainArea
    Loader {
        id: mainArea
        anchors {
            top: toolBar.bottom
            left: parent.left
            topMargin: toolBarMargin;
//            bottomMargin: mainMargin
//            leftMargin: mainMargin
//            rightMargin: mainMargin
        }
//        width: parent.width - 2*mainMargin
        width: parent.width
        height: parent.height - toolBarHeight - 3*toolBarMargin - playerBar.height
    }




    function changeMainMenu(selectedMenu){
        console.log("New idx: "+selectedMenu)
        for (var i = 0; i < toolBar.children.length; ++i)
        {
            if (i !== selectedMenu)
                toolBar.children[i].state = "Inactive";
        }

        if (selectedMenu === 0)
        {
            mainArea.sourceComponent = playlistPage;
        }
        else
        {

            mainArea.setSource("SimpleMainArea.qml");
            mainArea.item.lbl.text = toolBarModel.get(selectedMenu).name;//menuList[selectedMenu];
            mainArea.item.color    = toolBarModel.get(selectedMenu).color;
            mainArea.opacity = 0.8
        }
    }

    ToolBarButton {
        id: nav_menu
        anchors {
            top: parent.top
            left: parent.left
            topMargin: toolBarMargin;
            leftMargin: toolBarMargin;
        }
        height: toolBar.height
        width: toolBarButtonWidth
        imagePath: "icons/nav_menu.png"
        onSelected:  drawer.open();
    }

    Row {
        id: toolBar
        anchors {
            top: parent.top
            left: nav_menu.right
            topMargin: toolBarMargin;
            leftMargin: 2*mainMargin
//            leftMargin: 2*toolBarMargin + (parent.width - width - 3*toolBarMargin - nav_menu.width)/2
//            horizontalCenter: parent.horizontalCenter
        }

        height : toolBarHeight
        spacing: toolBarSpacing

        Repeater {
            model: toolBarModel; //menuList
            ToolBarButton {
                id: button
                height: toolBar.height
                width: toolBarButtonWidth

//                imagePath: "icons/" + model.modelData + ".png"
                imagePath: "icons/" + model.name + ".png"
                barIndex: model.index
//                state: root.toolBarIndex === barIndex ? "Selected" : "Inactive"
//                onSelected: root.toolBarIndex = barIndex
                state: barIndex === root.toolBarIndex ?  "Selected" : "Inactive"
                onSelected: changeMainMenu(barIndex)
            }
        }
    }


    Rectangle {
        id: playerBar
        height: 2*toolBarMargin + headerButtonSize +trackSlider.height
        width: parent.width - 2*toolBarMargin
        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: toolBarMargin
            rightMargin: toolBarMargin


//            leftMargin: 2*toolBarMargin + (parent.width - width - 3*toolBarMargin - nav_menu.width)/2
//            horizontalCenter: parent.horizontalCenter
        }
//        border.color: "black";
//        border.width: 2
        color: "transparent"

        Row {
            id: trackRow
            anchors{
                top: parent.top
//                topMargin: toolBarMargin
                right: parent.right
//                leftMargin: toolBarSpacing
            }

            width: parent.width

            Image {
                id: downSong
//                anchors{
//                    top: parent.top
//                    //                topMargin: toolBarMargin
//                    left: parent.left
//                    //                leftMargin: toolBarSpacing
//                }
                source: "icons/nav_downloads.png";
                fillMode: Image.PreserveAspectFit;

                height: headerButtonSize
                width: headerButtonSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                       print("[MainApp] downSong clicked! TODO...")
                    }
                }
            }

            Slider {
                id: trackSlider
                value: 1/3

//                anchors{
//                    top: parent.top
//                    topMargin: toolBarMargin
//                    horizontalCenter: parent.horizontalCenter
//                }

                width: parent.width - 3*headerButtonSize

                background: Rectangle {
                    x: trackSlider.leftPadding
                    y: trackSlider.topPadding + trackSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: trackSlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bdbebf"

                    Rectangle {
                        width: trackSlider.visualPosition * parent.width
                        height: parent.height
                        color: "blue";//"#21be2b"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: trackSlider.leftPadding + trackSlider.visualPosition * (trackSlider.availableWidth - width)
                    y: trackSlider.topPadding + trackSlider.availableHeight / 2 - height / 2
                    implicitWidth: 22
                    implicitHeight: 22
                    radius: 13
                    color: trackSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }

                onPressedChanged: {
                    if (!pressed)
                    {
                        print("onPressedChanged trackPosition: "+Math.round(value*trackLength))
                        cppRemote.setTrackPostion(Math.round(value*trackLength))
                    }
                }
//                onMoved:{
////                    print("new trackPosition: "+value*trackLength)
//                }
            }

            ImageButton {
                id: repeatButton
                size: headerButtonSize
                source: "icons/ab_repeat_off.png";
                onClicked: {
                    print("[MainApp] repeatButton clicked! TODO...")
                    repeatMenu.open()
                }

                Menu {
                    id: repeatMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        icon.source: "icons/ab_repeat_off.png";
                        text: qsTr("Don't Repeat")
                        onTriggered: {
                            cppRemote.repeat(0)
                            updateRepeat(0)
                        }
                    }
                    Action {
                        icon.source: "icons/ab_repeat_track.png";
                        text: qsTr("Repeat Track")
                        onTriggered: {
                            cppRemote.repeat(1)
                            updateRepeat(1)
                        }
                    }
                    Action {
                        icon.source: "icons/ab_repeat_album.png";
                        text: qsTr("Repeat Album")
                        onTriggered: {
                            cppRemote.repeat(2)
                            updateRepeat(2)
                        }
                    }
                    Action {
                        icon.source: "icons/ab_repeat_playlist.png";
                        text: qsTr("Repeat Playlist")
                        onTriggered: {
                            cppRemote.repeat(3)
                            updateRepeat(3)
                        }
                    }
                }
            }
            ImageButton {
                id: shuffleButton
                size: headerButtonSize
                source: "icons/ab_shuffle_off.png";
                onClicked: {
                    print("[MainApp] shuffleButton clicked! TODO...")
                    shuffleMenu.open()
                }

                Menu {
                    id: shuffleMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        icon.source: "icons/ab_shuffle_off.png";
                        text: qsTr("Don't Shuffle")
                        onTriggered: {
                            cppRemote.shuffle(0)
                            updateShuffle(0)
                        }
                    }
                    Action {
                        icon.source: "icons/ab_shuffle.png";
                        text: qsTr("Shuffle All")
                        onTriggered: {
                            cppRemote.shuffle(1)
                            updateShuffle(1)
                        }
                    }
                    Action {
                        icon.source: "icons/ab_shuffle_album.png";
                        text: qsTr("Shuffle tracks in this Albums")
                        onTriggered: {
                            cppRemote.shuffle(2)
                            updateShuffle(2)
                        }
                    }
                    Action {
                        icon.source: "icons/ab_shuffle_albums.png";
                        text: qsTr("Shuffle Albums")
                        onTriggered: {
                            cppRemote.shuffle(3)
                            updateShuffle(3)
                        }
                    }
                }
            }
        }


        Text{
            id: trackPosition
            anchors{
                top: trackRow.top
                left: trackRow.left
                leftMargin: headerButtonSize + toolBarMargin
                topMargin: -5
            }

            text: ""
        }

        Text{
            id: trackDuration
            anchors{
                top: trackRow.top
                right: trackRow.right
                rightMargin: 2*headerButtonSize + toolBarMargin
                topMargin: -5
            }

            text: cppRemote.currentTrackDuration()
        }


        // Second line

        Row {
            id: commandsRow

            anchors{
                left: parent.left
                bottom: parent.bottom
                bottomMargin: toolBarMargin
            }
            spacing: 10

            ImageButton {
                id: previousSong
                size: headerButtonSize
                source: "icons/media-skip-backward.png";
                onClicked: {
                    print("[MainApp] previousSong clicked!")
                     cppRemote.previousSong();
                }
            }
            ImageButton {
                id: playSong
                size: headerButtonSize
                source: "icons/media-playback-start.png";
                onClicked: {
                    print("[MainApp] playSong clicked!")
                    cppRemote.playpause();
                    updatePlayerState();
                }
            }
            ImageButton {
                id: stopSong
                size: headerButtonSize
                source: "icons/media-playback-stop.png";
                onClicked: {
                    print("[MainApp] stopSong clicked!")
                     cppRemote.stop();
                     updatePlayerState();
                }
            }
            ImageButton {
                id: nextSong
                size: headerButtonSize
                source: "icons/media-skip-forward.png";
                onClicked: {
                    print("[MainApp] nextSong clicked!")
                     cppRemote.nextSong();
                }
            }
        }

        Slider {
            id: volumeSlider
            value: cppRemote.volume()/100

            width: parent.width - volPct.width - (headerButtonSize + commandsRow.spacing + toolBarMargin) * 4

            anchors{
                right: volPct.left
                bottom: parent.bottom
                bottomMargin: toolBarMargin
                rightMargin: toolBarMargin
            }

            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"

                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#21be2b"
                    radius: 2
                }
            }

            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 26
                implicitHeight: 26
                color: "transparent"
                Image{
                    source: "icons/sound.png"
                    fillMode: Image.PreserveAspectFit;
                    width: parent.width
                    height: parent.height
                }
            }

            onPressedChanged: {
                if (!pressed)
                {
                    print("onPressedChanged volume: "+Math.round(value*100))
                    cppRemote.setCurrentVolume(Math.round(value*100))
                    volPct.text = cppRemote.volumePct();
                }
            }

        }

        Text{
            id: volPct
            anchors{
                right: parent.right
//                bottom: parent.bottom
//                bottomMargin: toolBarMargin
                rightMargin: toolBarMargin
                verticalCenter: volumeSlider.verticalCenter
            }
            text: cppRemote.volumePct();
        }
    }


    function updatePlayerState(){
        var enableStop = true;
        if (cppRemote.isPlaying())
            playSong.source =  "icons/media-playback-pause.png";
        else if (cppRemote.isPaused())
            playSong.source =  "icons/media-playback-start.png";
        else{
            playSong.source =  "icons/media-playback-start.png";
            enableStop = false;
        }

       stopSong.enabled = enableStop
       stopSong.opacity = enableStop ? 1 : 0.5
    }


    Component.onCompleted: {
        changeMainMenu(toolBarIndex);
        updatePlayerState();
        updateRepeat(cppRemote.repeatMode());
        updateShuffle(cppRemote.shuffleMode());
    }

    function updateShuffle(mode){
        switch(mode)
        {
        case 0:
            shuffleButton.source = "icons/ab_shuffle_off.png";
            break;
        case 1:
            shuffleButton.source = "icons/ab_shuffle.png";
            break;
        case 2:
            shuffleButton.source = "icons/ab_shuffle_album.png";
            break;
        case 3:
            shuffleButton.source = "icons/ab_shuffle_albums.png";
            break;
        default:
            shuffleButton.source = "icons/ab_shuffle_off.png";
            break;
        }
    }

    function updateRepeat(mode){
        switch(mode)
        {
        case 0:
            repeatButton.source = "icons/ab_repeat_off.png";
            break;
        case 1:
            repeatButton.source = "icons/ab_repeat_track.png";
            break;
        case 2:
            repeatButton.source = "icons/ab_repeat_album.png";
            break;
        case 3:
            repeatButton.source = "icons/ab_repeat_playlist.png";
            break;
        default:
            repeatButton.source = "icons/ab_repeat_off.png";
            break;
        }
    }

    Connections{
        target: cppRemote

        function onCurrentSongLength(length, pretty_length){
            print("new track duration: "+pretty_length + " ("+length+")")
            trackLength = length
            trackDuration.text = pretty_length;
        }


        function onCurrentTrackPosition(pos){
            trackPosition.text = cppRemote.prettyLength(pos)
            trackSlider.value  = pos / trackLength
        }

        function onVolume(vol){
            volPct = cppRemote.volumePct()
            volumeSlider.value = vol / 100;
        }

        function onUpdateEngineState(){
            updatePlayerState();
        }

        function onUpdateShuffle(mode){
            updateShuffle(mode);
        }
        function onUpdateRepeat(mode){
            updateRepeat(mode);
        }
    }


    Component {
        id: playlistPage

        Playlist {
            anchors.fill  : parent
        }
    }

    Dialog {
        id: todoDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        title: "TODO"

        Label {
            text: "this feature is not implemented yet..."
        }
    }

    Drawer {
        id: drawer
        width: parent.width * 2/3
        height: parent.height

//        height: drawerContent.height //parent.height / 2
        // Make drawer comes from the left
        edge: Qt.LeftEdge
//        opacity: 0.8

        Column {
            anchors.fill: parent
//            anchors.topMargin: mainMargin
            spacing: toolBarMargin

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: bgGradiantStart }
                    GradientStop { position: 1.0; color: bgGradiantStop }
                }
                width: drawer.width;// - 20;
                height: 100
                Row {
                    height: parent.height
                    width: parent.width
                    spacing: toolBarSpacing

                    Image {
                        id: drawerLogo
                        source: "icon_large.png";
                        fillMode: Image.PreserveAspectFit;
                        anchors.verticalCenter: parent.verticalCenter
                        height: 50
                        width: 50
                    }

                    Text {
                        width: parent.width - drawerLogo.width - toolBarSpacing
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: 20;
                        text: "Clementine on localhost"
                        wrapMode: Text.WordWrap
                    }
                }
            }

            ItemDelegate {
                id: settings

                text: qsTr("Settings")
                icon {
                    source: "icons/nav_settings.png"
//                    height: 30
                }

                onClicked: {
                    console.log("onClicked " + settings.text);
                    drawer.close();
                    todoDialog.open();
                }
            }

            ItemDelegate {
                id: downloads

                text: qsTr("Downloads")
                icon {
                    source: "icons/nav_downloads.png"
                }

                onClicked: {
                    console.log("onClicked " + downloads.text);
                    drawer.close();
                    todoDialog.open();
                }
            }

            ItemDelegate {
                id: donate

                text: qsTr("Donate")
                icon {
                    source: "icons/nav_donate.png"
                }

                onClicked: {
                    console.log("onClicked " + donate.text)
                    drawer.close();
                    todoDialog.open();
                }
            }

            ItemDelegate {
                id: about

                text: qsTr("About")
                icon {
                    source: "icon.png"
                }

                onClicked: {
                    console.log("onClicked " + about.text)
                    drawer.close();
                    todoDialog.open();
                }
            }


            ItemDelegate {
                id: logout
//                height: 30

//                width: parent.width

                text: qsTr("Disconnect")
                icon {
//                    source: "icons/logout.png"
                    source: "icons/nav_quit.png"
                }

                onClicked: {
                    console.log("onClicked " + logout.text)
                    cppRemote.disconnectFromServer();
                }
            }
        }
    }
}
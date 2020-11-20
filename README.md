<img align="left" width="80" height="80" src="https://raw.githubusercontent.com/mbruel/ClementineRemote/main/src/data/icon.png" alt="ClementineRemote">

# ClemRemote v1.0-rc1
Remote for [Clementine Music Player](https://www.clementine-player.org/) ([github](https://github.com/clementine-player/Clementine)) developped in C++/QT5/QML to be available on any OS. <br/>
Its main goal was to add the Files View missing in the Android Remote.<br/>
I've also made it like a player, so you always see the running track, can pause or go next..<br/>
I've built the v1.0-rc1 for [Linux](https://github.com/mbruel/ClementineRemote/releases/download/v1.0-rc1/ClemRemote_v1.0-rc1-x86_64.AppImage), [MacOS](https://github.com/mbruel/ClementineRemote/releases/download/v1.0-rc1/ClemRemote_v1.0-rc1.dmg) and [Win64](https://github.com/mbruel/ClementineRemote/releases/download/v1.0-rc1/ClemRemote_v1.0-rc1_win64.zip). I'll publish it soon on iOS and Android once I've got some feedback.
<br/><br/>
<img width="200" src="https://raw.githubusercontent.com/mbruel/ClementineRemote/main/pics/ClementineRemote_Playlist.png" alt="ClementineRemote on Debian"/> <img width="200" src="https://raw.githubusercontent.com/mbruel/ClementineRemote/main/pics/ClementineRemote_Files.png" alt="ClementineRemote on iPhone SE"/> <img width="200" src="https://raw.githubusercontent.com/mbruel/ClementineRemote/main/pics/ClementineRemote_Library.png" alt="ClementineRemote on iPhone SE"/> <img width="200" src="https://raw.githubusercontent.com/mbruel/ClementineRemote/main/pics/ClementineRemote_Radio.png" alt="ClementineRemote on iPhone SE"/><br/>

### Features
#### Playlist Menu
From the header Menu:
- Change Playlist (from those opened in Clementine on the server)
- search for text (regular expression for track name, album and artist)
- save/favourite a Playlist (requires Clementine v1.4.0rc1ClemRemote)
- rename current playlist (requires Clementine v1.4.0rc1ClemRemote)
- clear current playlist (requires Clementine v1.4.0rc1ClemRemote)
- close current playlist
- download current playlist
- open a closed playlist that is in favourite (requires Clementine v1.4.0rc1ClemRemote)
- create a new playlist (requires Clementine v1.4.0rc1ClemRemote)

You can also:
- **Double click on a Track** to play it
- **Long press on a Track** to switch in **Edit mode** from where you can select more tracks or all (cf button in the bottom) to:
- Copy tracks to another Playlist (requires Clementine v1.4.0rc1ClemRemote)
- download the selected tracks (requires Clementine v1.4.0rc1ClemRemote)
- remove the selected tracks from the playlist.
- click on the cursor button to exit the **Edit mode**

#### Files Menu (requires Clementine v1.4.0rc1ClemRemote)


#### Library Menu


#### Internet Radio Menu (requires Clementine v1.4.0rc1ClemRemote)

#### Global Search Menu
As I don't use any Internet Storage, I've not implemented this part...<br/>
If you'd be interested in it, please open a [request issue here on GitHub](https://github.com/mbruel/ClementineRemote/issues) or drop me an email at Matthieu.Bruel@gmail.com


### Clementine version
The modification needed in Clementine can be found on [my fork](https://github.com/mbruel/Clementine). I've asked 4 pull requests that are not yet merged so I've build the release myself for Linux, MacOS and Windows (using the Clementine workflow on my branch)<br/>
**You can download and try [Clementine v1.4.0rc1ClemRemote](https://github.com/mbruel/Clementine/releases/tag/1.4.0rc1ClemRemote)** (you then need to activate the network remote in [Tools -- Preferences -- Network Remote](https://raw.githubusercontent.com/mbruel/ClementineRemote/main/pics/Clementine_Network_Remote_Settings.png))


### How to build
#### Dependencies:
- build-essential (C++ compiler, libstdc++, make,...)
- qt5-default (Qt5 libraries and headers)
- qt5-qmake (to generate the moc files and create the Makefile)
- protobuf-compiler and libprotobuf-dev

#### Build:
- go to `src/protobuf/` and generate the protobuf C++ file with the command `protoc remotecontrolmessages.proto --cpp_out=.`
- go to `src`
- qmake
- make


### Donations
I'm Freelance nowadays, working on several personal projects, so if you use the app and would like to contribute to the effort, feel free to donate what you can.<br/>
<br/>
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=W2C236U6JNTUA&item_name=ClementineRemote&currency_code=EUR"><img align="left" src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" alt="ClementineRemote"></a>
 or in Bitcoin at this address: **3BGbnvnnBCCqrGuq1ytRqUMciAyMXjXAv6**
<img align="right" align="bottom" width="120" height="120" src="https://raw.githubusercontent.com/mbruel/ngPost/master/pics/btc_qr.gif" alt="ngPost_QR">

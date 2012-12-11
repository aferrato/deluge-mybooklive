#Install Deluge on My Book Live
This script will install the latest version of the BitTorrent client Deluge on your Western Digital My Book Live
 
The script has been created to simplify the installation of the latest version of Deluge on my WD MyBook Live. I know, it could be done much better, but it works for me. 

**I do not feel in any way responsible for loss of data or brick system.
I had no issues, but I warned you!**

##What the script does?
1. Make a backup of the file /etc/apt/sources.list
2. Look for Squeeze repository in the sources.list and comments all repositories except Lenny
3. Look for Lenny repository in the sources.list and add it
4. Create the new sources.list for Deluge
5. Install python-libtorrent
6. Install deluge deluged deluge-web deluge-console
7. Create Deluge's configurations files
8. Launching the daemon

##How to use?
`$ wget https://github.com/ferra-andre/deluge-mybooklive/master/install-deluge.sh`

`$ chmod +x install-deluge.sh`

`$ sh install-deluge.sh`

###Or in one line:
`$ wget https://github.com/ferra-andre/deluge-mybooklive/master/install-deluge.sh && chmod +x install-deluge.sh && sh install-deluge.sh`

##FAQ
* ###I hate you, I can not access my my book live!
I warned you, it could happen, try to recover it with this great script: [http://mybookworld.wikidot.com/forum/t-368098/debricking-script-that-can-keep-data](http://mybookworld.wikidot.com/forum/t-368098/debricking-script-that-can-keep-data) 
* ###How do I access Deluge?
Open the browser and enter: [http://ip.my.book.live:8112](http://ip.my.book.live:8112)

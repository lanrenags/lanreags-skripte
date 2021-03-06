#!/bin/bash
######################################################
#                                                    #
#            LANrena - The LAN Code                  #
#                 start-Skript                       #
#                                                    #
#                   Copyright:                       #
#                                                    #
#           Marcus "LR|^bnl" Bauernheim              #
#          Christoph "Rattlesanke" Raible            #
#                                                    #
######################################################

#Variables

MASTER='192.168.2.146'
DIR='/usr/local/games/'

#Funcations

do_abfrage_port()
{
  clear;
  echo "######################################################"
  echo "#                 PORT UEBERSICHT                    #"
  echo "#                                                    #"
  echo "#  ENGINE | PORTLIST           | COMMENTS            #"
  echo "#  ------------------------------------------------- #"
  echo "#  hl     | 27015 - 27019      | Step +1             #"
  echo "#  cod    | 28960 - 28970      | Step +1             #"
  echo "#  ut     | 7777  - 7787       | Step +2             #"
  echo "#  quake  | 27960  - 27970     | Step +1             #"
  echo "#  bf     | ---                | ---                 #"
  echo "#  tmnf   | ---                | ---                 #"
  echo "######################################################"
  echo ""

  echo -n "Bitte Port fuer den neuen Server festlegen: "
  read PORT;
  if [ "$ENGINE" == "hl" ]; then
    if [ $PORT -lt 27015 -o $PORT -gt 27019 ]; then
      echo "Der Port muss zwischen 27015 und 27019 liegen"
      do_abfrage_port;
    fi
  elif [ "$ENGINE" == "cod" ];then
    if [ $PORT -lt 28960 -o $PORT -gt 28970 ]; then
      echo "Der Port muss zwischen 28960 und 28970 liegen"
      do_abfrage_port;
    fi
  else
    echo "Alles OK :-)"
  fi
}

do_abfrage_game()
{
  clear;
  echo "Bitte Spiel auswaehlen: " 
  echo "";
  echo "--------------------------------";
  echo "------  Turnier Games  ---------";
  echo "--------------------------------";
  echo "1) Counter-Strike";
  echo "2) Counter-Strike:Source"
  echo "3) Call of Duty 4";
  echo "4) Team Fortress 2";
  echo "5) TrackMania Nations Forever";
  echo "6) Quake 3";
  echo "7) Unreal Tournament 2004";
  echo "8) CS-GO Turnier"
  echo "9) CSS-Gungame Turnier"
  echo "--------------------------------";
  echo "------  Sonstige Games ---------";
  echo "--------------------------------";
  echo "10) Battlefield 2";
  echo "11) Left4Dead 2";
  echo "12) CSS-Gungame";
  echo "13) CSS-Deathmatch";
  echo "14) CSS-Zombie";
  echo "15) CS1.6-Gungame";
  echo "16) CS1.6-Deathmatch";
  echo "17) HL2-DM";
  echo -n "Spielnummer (1-14): "
  read GAME_SELECT;

  case $GAME_SELECT in

    1)
      GAME=cstrike;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    2)
      GAME=css;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    3)
      GAME=cod;
      ENGINE=cod;
      do_abfrage_port;
      ;;
    4)
      GAME=tf;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    5)
      GAME=tmnf;
      ENGINE=tmnf;
      do_abfrage_port;
      ;;
    6)
      GAME=quake;
      ENGINE=quake;
      do_abfrage_port;
      ;;
    7)
      GAME=ut;
      ENGINE=ut;
      do_abfrage_port;
      ;;
    8)
      GAME=csgo;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    9)
      GAME=cssggt;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    10)
      GAME=bf;
      ENGINE=bf;
      do_abfrage_port;
      ;;
    11)
      GAME=ldd;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    12)
      GAME=cssgg;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    13)
      GAME=cssdm;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    14)
      GAME=csszm;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    15)
      GAME=cstrikegg;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    16)
      GAME=cstrikedm;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    17)
      GAME=hldm;
      ENGINE=hl;
      do_abfrage_port;
      ;;
    * )
      for i in 5 4 3 2 1 
        do
          echo  "Ungueltige Eingabe! Bitte erneut versuchen in '$i' Sekunden";
          sleep 1;
        done
        do_abfrage_game;
        ;;
esac
}

do_rsync()
{
  /usr/bin/sudo -u $GAME$PORT /usr/bin/rsync -av root@$MASTER:$DIR/$GAME/ /home/$GAME$PORT;
}

check_requ()
{
  if [ `egrep -ic $GAME$PORT /etc/passwd` = 0 ];then
    echo "User nicht gefunden und wird jetzt angelegt";
    useradd $GAME$PORT -m -d /home/$GAME$PORT -s /bin/bash;
    check_requ;
  elif [ -d /home/$GAME$PORT ];then
    echo "Ziel vorhanden. Download beginnt in kuerze......";
    sleep 2;
    do_rsync;
  else
    echo "Verzeichnis /home/$GAME$PORT existiert nicht und wird nun angelegt";
    mkdir /home/$GAME$PORT;
    do_rsync;
  fi
}


# Main
do_abfrage_game;
check_requ;

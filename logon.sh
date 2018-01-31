#!/bin/sh

# (Standard 2 clause BSD licence)
# 
# Copyright (c) 2018 Nathan Jackson <njackson7899@gmail.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Add the directory containing this script to the path
case "$0" in
    /*) PATH=$PATH:$(dirname $0) ;;
    *)  PATH=$PATH:$(dirname $PWD/$0) ;;
esac

# Global variables
# $a      Last input
# $prompt Last prompt
# $phase  Interaction phase (connect|logon|games|falken|gtn)

# Check the input ($a) against actual in-film input and fixup display if needed
actual()
{
    if [ "$a" != "$1" ] ; then
	tput cuu1 ; tput dl1; echo "$prompt$1"
    fi
}

# Call actual, then output a new line and delay
actual_d()
{
    actual "$1"
    echo ; sleep 1
}

readline()
{
  wopr -i
}

phase_connect()
{
clear
wopr -c 15 "									" \
     "									" \
     "									"
}

logout()
{
	wopr -c 800 .....
	wopr -- "" "--LOGOUT--" "" ""
	sleep 1
	phase=logon
}

phase_logon()
{
    prompt="LOGON:  "
    wopr -n "$prompt"
    a="$(readline)"

    case "$a" in
	*"Help Logon" | *"help logon" | *Help | *help )
	    actual_d "Help Logon"
	    wopr "HELP NOT AVAILABLE"
	    ;;
	*Joshua* | *joshua*)
	    actual_d "Joshua"
	    phase=startup
	    return
	    ;;
	*"Help Games" | *"help games")
	    actual_d "Help Games"
	    wopr "'GAMES' REFERS TO MODELS, SIMULATIONS AND GAMES" \
	         "WHICH HAVE TACTICAL AND STRATEGIC APPLICATIONS."
	    phase=games
	    ;;
        *)
            case "$a" in
                *Falkens-Maze)
	             actual_d Falkens-Maze
                     ;;
                *Armageddon)
	             actual_d Armageddon
                     ;;
                *)
	             actual_d 000001
                     ;;
            esac
	    wopr -- "IDENTIFICATION NOT RECOGNIZED BY SYSTEM" \
	         "--CONNECTION TERMINATED--" ""
	    sleep 1
	    osascript -e 'tell application "iTerm" to quit'
	    exit 0
	    ;;
    esac
    wopr '' ''
}

phase_games()
{ 
    prompt=
    a="$(readline)"

    case "$a" in
	"List Games" | "list games")
	    actual_d "List Games"
	    wopr -c 10 -l 550 -n "FALKEN'S MAZE
BLACK JACK
GIN RUMMY
HEARTS
BRIDGE
CHECKERS
CHESS
POKER
FIGHTER COMBAT
GUERRILLA ENGAGEMENT
DESERT WARFARE
AIR-TO-GROUND ACTIONS
THEATERWIDE TACTICAL WARFARE
THEATERWIDE BIOTOXIC AND CHEMICAL WARFARE

GLOBAL THERMONUCLEAR WAR"
	    ;;
	*War* | *war* ) # Actually endgame phase
	    actual_d "Global Thermonuclear War"
	    wopr "A STRANGE GAME." \
	         "THE ONLY WINNING MOVE IS" \
	         "NOT TO PLAY." \
		 ""
	    sleep 1.5
	    wopr "HOW ABOUT A NICE GAME OF CHESS?"
	    ;;
	*Joshua* | *joshua* )
	    actual_d "LOGON:  Joshua"
	    phase=falken
	    ;;
	'' )
	    phase=logon
	    ;;
    esac
    wopr '' ''
}

phase_startup()
{
	clear
    wopr -c 0 -l 25 "\
#45     11456          11009          11893          11972        11315
PRT CON. 3.4.5.  SECTRAN 9.4.3.                      PORT STAT: SD-345

(311) 699-7305
"
    clear
    printf "\n\n\n\n\n\n\n"
    wopr -c 0 -l 25 "\
(311) 767-8739
(311) 936-2364
-           PRT. STAT.                                   CRT. DEF.
||||||||||||||==================================================
FSKDJLSD: SDSDKJ: SBFJSL:                           DKSJL: SKFJJ: SDKFJLJ:
SYSPROC FUNCT READY                            ALT NET READY
CPU AUTH RY-345-AX3            SYSCOMP STATUS  ALL PORTS ACTIVE
22/34534.90/3209                                          11CVB-3904-3490
(311) 935-2364
"
    clear
    sleep 0.5
    wopr "GREETINGS PROFESSOR FALKEN." ""
	exit
}

phase_connect
phase=logon
while true; do
    phase_$phase
done
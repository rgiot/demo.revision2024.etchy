#!/bin/bash
set -e

# Try to find why replay is broken

basm PlayerAkm_basm.asm -o player.basm
rasm PlayerAkm_original.asm -o player.rasm && mv player.rasm.bin player.rasm

if diff player.basm player.rasm 
then
	echo "Great rasm  and basm assemble the player the same way"
else
	echo "Too bad: rasm and basm assemble the player differently" >&2
	exit -1
fi


basm krocket2_akm.asm -o krocket2_akm.basm
rasm krocket2_akm.asm -o krocket2_akm.rasm && mv krocket2_akm.rasm.bin krocket2_akm.rasm

if diff krocket2_akm.basm krocket2_akm.rasm 
then
	echo "Great rasm  and basm assemble the music the same way"
else
	echo "Too bad: rasm and basm assemble the music differently" >&2
	exit -1
fi

basm lookool_akm.asm -o lookool_akm.basm
rasm lookool_akm.asm -o lookool_akm.rasm && mv lookool_akm.rasm.bin lookool_akm.rasm

if diff lookool_akm.basm lookool_akm.rasm 
then
	echo "Great rasm  and basm assemble the music the same way"
else
	echo "Too bad: rasm and basm assemble the music differently" >&2
	exit -1
fi



# listen the two versions of the music. they seem good on both sides
rasm  test_replay.asm  && AceDL rasmoutput.sna
basm  test_replay.asm  --sna -o basmoutput.sna && AceDL basmoutput.sna

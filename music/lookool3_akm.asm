; Lookool, Song part, encoded in the AKM (minimalist) format V0.


Lookool_Start
Lookool_StartDisarkGenerateExternalLabel

Lookool_DisarkPointerRegionStart0
	dw Lookool_InstrumentIndexes	; Index table for the Instruments.
	dw Lookool_ArpeggioIndexes - 2	; Index table for the Arpeggios.
	dw Lookool_PitchIndexes - 2	; Index table for the Pitches.

; The subsongs references.
	dw Lookool_Subsong0
Lookool_DisarkPointerRegionEnd0

; The Instrument indexes.
Lookool_InstrumentIndexes
Lookool_DisarkPointerRegionStart1
	dw Lookool_Instrument0
	dw Lookool_Instrument1
	dw Lookool_Instrument2
	dw Lookool_Instrument3
	dw Lookool_Instrument4
	dw Lookool_Instrument5
	dw Lookool_Instrument6
	dw Lookool_Instrument7
Lookool_DisarkPointerRegionEnd1

; The Instrument.
Lookool_DisarkByteRegionStart2
Lookool_Instrument0
	db 255	; Speed.

Lookool_Instrument0Loop	db 0	; Volume: 0.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart3
	dw Lookool_Instrument0Loop	; Loops.
Lookool_DisarkPointerRegionEnd3

Lookool_Instrument1
	db 0	; Speed.

	db 125	; Volume: 15.
	dw -272	; Pitch: -272.

	db 57	; Volume: 14.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 33	; Volume: 8.

Lookool_Instrument1Loop	db 29	; Volume: 7.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart4
	dw Lookool_Instrument1Loop	; Loops.
Lookool_DisarkPointerRegionEnd4

Lookool_Instrument2
	db 0	; Speed.

	db 125	; Volume: 15.
	dw -16	; Pitch: -16.

	db 57	; Volume: 14.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 33	; Volume: 8.

Lookool_Instrument2Loop	db 29	; Volume: 7.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart5
	dw Lookool_Instrument2Loop	; Loops.
Lookool_DisarkPointerRegionEnd5

Lookool_Instrument3
	db 0	; Speed.

	db 189	; Volume: 15.
	db 1	; Arpeggio: 0.
	db 1	; Noise: 1.

	db 125	; Volume: 15.
	dw 68	; Pitch: 68.

	db 121	; Volume: 14.
	dw 164	; Pitch: 164.

	db 117	; Volume: 13.
	dw 260	; Pitch: 260.

	db 113	; Volume: 12.
	dw 340	; Pitch: 340.

	db 109	; Volume: 11.
	dw 420	; Pitch: 420.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart6
	dw Lookool_Instrument0Loop	; Loop to silence.
Lookool_DisarkPointerRegionEnd6

Lookool_Instrument4
	db 0	; Speed.

Lookool_Instrument4Loop	db 232	; Volume: 13.
	db 1	; Noise.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart7
	dw Lookool_Instrument4Loop	; Loops.
Lookool_DisarkPointerRegionEnd7

Lookool_Instrument5
	db 0	; Speed.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

Lookool_Instrument5Loop	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 105	; Volume: 10.
	dw -1	; Pitch: -1.

	db 105	; Volume: 10.
	dw -1	; Pitch: -1.

	db 105	; Volume: 10.
	dw -1	; Pitch: -1.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 105	; Volume: 10.
	dw 1	; Pitch: 1.

	db 105	; Volume: 10.
	dw 1	; Pitch: 1.

	db 105	; Volume: 10.
	dw 1	; Pitch: 1.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart8
	dw Lookool_Instrument5Loop	; Loops.
Lookool_DisarkPointerRegionEnd8

Lookool_Instrument6
	db 0	; Speed.

	db 169	; Volume: 10.
	db 232	; Arpeggio: -12.

	db 169	; Volume: 10.
	db 232	; Arpeggio: -12.

	db 169	; Volume: 10.
	db 232	; Arpeggio: -12.

	db 169	; Volume: 10.
	db 232	; Arpeggio: -12.

	db 169	; Volume: 10.
	db 232	; Arpeggio: -12.

	db 169	; Volume: 10.
	db 240	; Arpeggio: -8.

	db 169	; Volume: 10.
	db 240	; Arpeggio: -8.

	db 169	; Volume: 10.
	db 246	; Arpeggio: -5.

	db 169	; Volume: 10.
	db 246	; Arpeggio: -5.

	db 169	; Volume: 10.
	db 246	; Arpeggio: -5.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

Lookool_Instrument6Loop	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 105	; Volume: 10.
	dw -1	; Pitch: -1.

	db 105	; Volume: 10.
	dw -1	; Pitch: -1.

	db 105	; Volume: 10.
	dw -1	; Pitch: -1.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 105	; Volume: 10.
	dw 1	; Pitch: 1.

	db 105	; Volume: 10.
	dw 1	; Pitch: 1.

	db 105	; Volume: 10.
	dw 1	; Pitch: 1.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart9
	dw Lookool_Instrument6Loop	; Loops.
Lookool_DisarkPointerRegionEnd9

Lookool_Instrument7
	db 0	; Speed.

	db 189	; Volume: 15.
	db 24	; Arpeggio: 12.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

Lookool_Instrument7Loop	db 173	; Volume: 11.
	db 24	; Arpeggio: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 4	; End the instrument.
Lookool_DisarkPointerRegionStart10
	dw Lookool_Instrument7Loop	; Loops.
Lookool_DisarkPointerRegionEnd10

Lookool_DisarkByteRegionEnd2
Lookool_ArpeggioIndexes
Lookool_DisarkPointerRegionStart11
	dw Lookool_Arpeggio1
	dw Lookool_Arpeggio2
	dw Lookool_Arpeggio3
Lookool_DisarkPointerRegionEnd11

Lookool_DisarkByteRegionStart12
Lookool_Arpeggio1
	db 1	; Speed

	db 0	; Value: 0
	db 0	; Value: 0
	db 0	; Value: 0
	db 8	; Value: 4
	db 14	; Value: 7
	db 24	; Value: 12
	db 5 * 2 + 1	; Loops to index 5.
Lookool_Arpeggio2
	db 2	; Speed

	db 0	; Value: 0
	db 2	; Value: 1
	db 1 * 2 + 1	; Loops to index 1.
Lookool_Arpeggio3
	db 2	; Speed

	db 0	; Value: 0
	db 4	; Value: 2
	db 1 * 2 + 1	; Loops to index 1.
Lookool_DisarkByteRegionEnd12

Lookool_PitchIndexes
Lookool_DisarkPointerRegionStart13
	dw Lookool_Pitch1
Lookool_DisarkPointerRegionEnd13

Lookool_DisarkByteRegionStart14
Lookool_Pitch1
	db 0	; Speed

	db -18	; Value: -9
	db 0 * 2 + 1	; Loops to index 0.
Lookool_DisarkByteRegionEnd14

; Lookool, Subsong 0.
; ----------------------------------

Lookool_Subsong0
Lookool_Subsong0DisarkPointerRegionStart0
	dw Lookool_Subsong0_NoteIndexes	; Index table for the notes.
	dw Lookool_Subsong0_TrackIndexes	; Index table for the Tracks.
Lookool_Subsong0DisarkPointerRegionEnd0

Lookool_Subsong0DisarkByteRegionStart1
	db 7	; Initial speed.

	db 5	; Most used instrument.
	db 7	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

	db 53	; Default start note in tracks.
	db 1	; Default start instrument in tracks.
	db 2	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
Lookool_Subsong0DisarkByteRegionEnd1

; The Linker.
Lookool_Subsong0DisarkByteRegionStart2
; Pattern 0
Lookool_Subsong0_Loop
	db 174	; State byte.
	db 31	; New height.
	db 0	; New transposition on channel 1.
	db ((Lookool_Subsong0_Track0 - ($ + 2)) & #ff00) / 256	; New track (0) for channel 1, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track0 - ($ + 1)) & 255)
	db 128	; New track (1) for channel 2, as a reference (index 0).
	db ((Lookool_Subsong0_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track2 - ($ + 1)) & 255)

; Pattern 1
	db 136	; State byte.
	db 129	; New track (7) for channel 1, as a reference (index 1).
	db 129	; New track (7) for channel 3, as a reference (index 1).

; Pattern 2
	db 136	; State byte.
	db ((Lookool_Subsong0_Track0 - ($ + 2)) & #ff00) / 256	; New track (0) for channel 1, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track0 - ($ + 1)) & 255)
	db ((Lookool_Subsong0_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track2 - ($ + 1)) & 255)

; Pattern 3
	db 136	; State byte.
	db 129	; New track (7) for channel 1, as a reference (index 1).
	db 129	; New track (7) for channel 3, as a reference (index 1).

; Pattern 4
	db 168	; State byte.
	db ((Lookool_Subsong0_Track5 - ($ + 2)) & #ff00) / 256	; New track (5) for channel 1, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track5 - ($ + 1)) & 255)
	db 130	; New track (4) for channel 2, as a reference (index 2).
	db ((Lookool_Subsong0_Track3 - ($ + 2)) & #ff00) / 256	; New track (3) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track3 - ($ + 1)) & 255)

; Pattern 5
	db 8	; State byte.
	db ((Lookool_Subsong0_Track10 - ($ + 2)) & #ff00) / 256	; New track (10) for channel 1, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track10 - ($ + 1)) & 255)

; Pattern 6
	db 136	; State byte.
	db ((Lookool_Subsong0_Track6 - ($ + 2)) & #ff00) / 256	; New track (6) for channel 1, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track6 - ($ + 1)) & 255)
	db ((Lookool_Subsong0_Track8 - ($ + 2)) & #ff00) / 256	; New track (8) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track8 - ($ + 1)) & 255)

; Pattern 7
	db 0	; State byte.

; Pattern 8
	db 168	; State byte.
	db 131	; New track (11) for channel 1, as a reference (index 3).
	db ((Lookool_Subsong0_Track9 - ($ + 2)) & #ff00) / 256	; New track (9) for channel 2, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track9 - ($ + 1)) & 255)
	db ((Lookool_Subsong0_Track12 - ($ + 2)) & #ff00) / 256	; New track (12) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track12 - ($ + 1)) & 255)

; Pattern 9
	db 160	; State byte.
	db ((Lookool_Subsong0_Track13 - ($ + 2)) & #ff00) / 256	; New track (13) for channel 2, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track13 - ($ + 1)) & 255)
	db ((Lookool_Subsong0_Track14 - ($ + 2)) & #ff00) / 256	; New track (14) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track14 - ($ + 1)) & 255)

; Pattern 10
	db 164	; State byte.
	db 12	; New transposition on channel 1.
	db ((Lookool_Subsong0_Track9 - ($ + 2)) & #ff00) / 256	; New track (9) for channel 2, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track9 - ($ + 1)) & 255)
	db ((Lookool_Subsong0_Track12 - ($ + 2)) & #ff00) / 256	; New track (12) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track12 - ($ + 1)) & 255)

; Pattern 11
	db 160	; State byte.
	db ((Lookool_Subsong0_Track13 - ($ + 2)) & #ff00) / 256	; New track (13) for channel 2, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track13 - ($ + 1)) & 255)
	db ((Lookool_Subsong0_Track14 - ($ + 2)) & #ff00) / 256	; New track (14) for channel 3, as an offset. Offset MSB, then LSB.
	db ((Lookool_Subsong0_Track14 - ($ + 1)) & 255)

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
Lookool_Subsong0DisarkByteRegionEnd2
Lookool_Subsong0DisarkPointerRegionStart3
	dw Lookool_Subsong0_Loop

Lookool_Subsong0DisarkPointerRegionEnd3
; The indexes of the tracks.
Lookool_Subsong0_TrackIndexes
Lookool_Subsong0DisarkPointerRegionStart4
	dw Lookool_Subsong0_Track1	; Track 1, index 0.
	dw Lookool_Subsong0_Track7	; Track 7, index 1.
	dw Lookool_Subsong0_Track4	; Track 4, index 2.
	dw Lookool_Subsong0_Track11	; Track 11, index 3.
Lookool_Subsong0DisarkPointerRegionEnd4

Lookool_Subsong0DisarkByteRegionStart5
Lookool_Subsong0_Track0
	db 12	; Note with effects flag.
	db 139	; Note reference (11). Secondary wait (1).
	db 0	;    Reset effect, with inverted volume: 0.
	db 137	; Note reference (9). Secondary wait (1).
	db 73	; Note reference (9). Primary wait (0).
	db 67	; Note reference (3). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 194	; Note reference (2). New wait (3).
	db 3	;   Escape wait value.
	db 66	; Note reference (2). Primary wait (0).
	db 69	; Note reference (5). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 195	; Note reference (3). New wait (2).
	db 2	;   Escape wait value.
	db 131	; Note reference (3). Secondary wait (1).
	db 67	; Note reference (3). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 197	; Note reference (5). New wait (3).
	db 3	;   Escape wait value.
	db 69	; Note reference (5). Primary wait (0).
	db 69	; Note reference (5). Primary wait (0).
	db 78	; New escaped note: 20. Primary wait (0).
	db 20	;   Escape note value.
	db 78	; New escaped note: 19. Primary wait (0).
	db 19	;   Escape note value.
	db 203	; Note reference (11). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track1
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 0	;    Reset effect, with inverted volume: 0.
	db 190	; New instrument (4). New escaped note: 36. Secondary wait (1).
	db 36	;   Escape note value.
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 191	; New instrument (4). Same escaped note: 36. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 191	; New instrument (4). Same escaped note: 36. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 191	; New instrument (4). Same escaped note: 36. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 191	; New instrument (4). Same escaped note: 36. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 191	; New instrument (4). Same escaped note: 36. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 191	; New instrument (4). Same escaped note: 36. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 191	; New instrument (4). Same escaped note: 36. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 244	; New instrument (3). Note reference (4). New wait (127).
	db 3	;   Escape instrument value.
	db 127	;   Escape wait value.
	db 34	;    Volume effect, with inverted volume: 2.

Lookool_Subsong0_Track2
	db 12	; Note with effects flag.
	db 139	; Note reference (11). Secondary wait (1).
	db 1	;    Reset effect, with inverted volume: 0.
	db 24	;    Pitch table effect 1.
	db 137	; Note reference (9). Secondary wait (1).
	db 73	; Note reference (9). Primary wait (0).
	db 67	; Note reference (3). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 194	; Note reference (2). New wait (3).
	db 3	;   Escape wait value.
	db 66	; Note reference (2). Primary wait (0).
	db 69	; Note reference (5). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 195	; Note reference (3). New wait (2).
	db 2	;   Escape wait value.
	db 131	; Note reference (3). Secondary wait (1).
	db 67	; Note reference (3). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 197	; Note reference (5). New wait (3).
	db 3	;   Escape wait value.
	db 69	; Note reference (5). Primary wait (0).
	db 69	; Note reference (5). Primary wait (0).
	db 78	; New escaped note: 20. Primary wait (0).
	db 20	;   Escape note value.
	db 78	; New escaped note: 19. Primary wait (0).
	db 19	;   Escape note value.
	db 203	; Note reference (11). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track3
	db 141	; Secondary wait (1).
	db 12	; Note with effects flag.
	db 95	; Primary instrument (5). Same escaped note: 53. Primary wait (0).
	db 48	;    Reset effect, with inverted volume: 3.
	db 49	; New instrument (6). Note reference (1). 
	db 6	;   Escape instrument value.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 154	; Primary instrument (5). Note reference (10). Secondary wait (1).
	db 214	; Primary instrument (5). Note reference (6). New wait (3).
	db 3	;   Escape wait value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 30	; Primary instrument (5). New escaped note: 68. 
	db 68	;   Escape note value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 159	; Primary instrument (5). Same escaped note: 62. Secondary wait (1).
	db 144	; Primary instrument (5). Note reference (0). Secondary wait (1).
	db 158	; Primary instrument (5). New escaped note: 58. Secondary wait (1).
	db 58	;   Escape note value.
	db 208	; Primary instrument (5). Note reference (0). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track4
	db 12	; Note with effects flag.
	db 95	; Primary instrument (5). Same escaped note: 53. Primary wait (0).
	db 0	;    Reset effect, with inverted volume: 0.
	db 49	; New instrument (6). Note reference (1). 
	db 6	;   Escape instrument value.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 154	; Primary instrument (5). Note reference (10). Secondary wait (1).
	db 214	; Primary instrument (5). Note reference (6). New wait (3).
	db 3	;   Escape wait value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 30	; Primary instrument (5). New escaped note: 68. 
	db 68	;   Escape note value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 159	; Primary instrument (5). Same escaped note: 62. Secondary wait (1).
	db 144	; Primary instrument (5). Note reference (0). Secondary wait (1).
	db 158	; Primary instrument (5). New escaped note: 58. Secondary wait (1).
	db 58	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 222	; Primary instrument (5). New escaped note: 62. New wait (127).
	db 62	;   Escape note value.
	db 127	;   Escape wait value.

Lookool_Subsong0_Track5
	db 254	; New instrument (0). New escaped note: 48. New wait (4).
	db 48	;   Escape note value.
	db 0	;   Escape instrument value.
	db 4	;   Escape wait value.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 53. Primary wait (0).
	db 53	;   Escape note value.
	db 80	;    Reset effect, with inverted volume: 5.
	db 221	; Effect only. New wait (2).
	db 2	;   Escape wait value.
	db 22	;    Arpeggio table effect 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 6	;    Arpeggio table effect 0.
	db 154	; Primary instrument (5). Note reference (10). Secondary wait (1).
	db 214	; Primary instrument (5). Note reference (6). New wait (3).
	db 3	;   Escape wait value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 30	; Primary instrument (5). New escaped note: 68. 
	db 68	;   Escape note value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 159	; Primary instrument (5). Same escaped note: 62. Secondary wait (1).
	db 208	; Primary instrument (5). Note reference (0). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track6
	db 12	; Note with effects flag.
	db 171	; Secondary instrument (7). Note reference (11). Secondary wait (1).
	db 0	;    Reset effect, with inverted volume: 0.
	db 169	; Secondary instrument (7). Note reference (9). Secondary wait (1).
	db 105	; Secondary instrument (7). Note reference (9). Primary wait (0).
	db 99	; Secondary instrument (7). Note reference (3). Primary wait (0).
	db 103	; Secondary instrument (7). Note reference (7). Primary wait (0).
	db 226	; Secondary instrument (7). Note reference (2). New wait (3).
	db 3	;   Escape wait value.
	db 107	; Secondary instrument (7). Note reference (11). Primary wait (0).
	db 110	; Secondary instrument (7). New escaped note: 20. Primary wait (0).
	db 20	;   Escape note value.
	db 101	; Secondary instrument (7). Note reference (5). Primary wait (0).
	db 98	; Secondary instrument (7). Note reference (2). Primary wait (0).
	db 47	; Secondary instrument (7). Same escaped note: 20. 
	db 111	; Secondary instrument (7). Same escaped note: 20. Primary wait (0).
	db 98	; Secondary instrument (7). Note reference (2). Primary wait (0).
	db 103	; Secondary instrument (7). Note reference (7). Primary wait (0).
	db 99	; Secondary instrument (7). Note reference (3). Primary wait (0).
	db 165	; Secondary instrument (7). Note reference (5). Secondary wait (1).
	db 99	; Secondary instrument (7). Note reference (3). Primary wait (0).
	db 103	; Secondary instrument (7). Note reference (7). Primary wait (0).
	db 169	; Secondary instrument (7). Note reference (9). Secondary wait (1).
	db 110	; Secondary instrument (7). New escaped note: 34. Primary wait (0).
	db 34	;   Escape note value.
	db 228	; Secondary instrument (7). Note reference (4). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track7
	db 141	; Secondary wait (1).
	db 137	; Note reference (9). Secondary wait (1).
	db 73	; Note reference (9). Primary wait (0).
	db 67	; Note reference (3). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 194	; Note reference (2). New wait (3).
	db 3	;   Escape wait value.
	db 66	; Note reference (2). Primary wait (0).
	db 69	; Note reference (5). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 195	; Note reference (3). New wait (2).
	db 2	;   Escape wait value.
	db 131	; Note reference (3). Secondary wait (1).
	db 67	; Note reference (3). Primary wait (0).
	db 71	; Note reference (7). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 133	; Note reference (5). Secondary wait (1).
	db 135	; Note reference (7). Secondary wait (1).
	db 137	; Note reference (9). Secondary wait (1).
	db 254	; New instrument (2). New escaped note: 34. New wait (127).
	db 34	;   Escape note value.
	db 2	;   Escape instrument value.
	db 127	;   Escape wait value.

Lookool_Subsong0_Track8
	db 12	; Note with effects flag.
	db 171	; Secondary instrument (7). Note reference (11). Secondary wait (1).
	db 17	;    Reset effect, with inverted volume: 1.
	db 24	;    Pitch table effect 1.
	db 169	; Secondary instrument (7). Note reference (9). Secondary wait (1).
	db 105	; Secondary instrument (7). Note reference (9). Primary wait (0).
	db 99	; Secondary instrument (7). Note reference (3). Primary wait (0).
	db 103	; Secondary instrument (7). Note reference (7). Primary wait (0).
	db 226	; Secondary instrument (7). Note reference (2). New wait (3).
	db 3	;   Escape wait value.
	db 107	; Secondary instrument (7). Note reference (11). Primary wait (0).
	db 110	; Secondary instrument (7). New escaped note: 20. Primary wait (0).
	db 20	;   Escape note value.
	db 101	; Secondary instrument (7). Note reference (5). Primary wait (0).
	db 98	; Secondary instrument (7). Note reference (2). Primary wait (0).
	db 227	; Secondary instrument (7). Note reference (3). New wait (2).
	db 2	;   Escape wait value.
	db 163	; Secondary instrument (7). Note reference (3). Secondary wait (1).
	db 99	; Secondary instrument (7). Note reference (3). Primary wait (0).
	db 103	; Secondary instrument (7). Note reference (7). Primary wait (0).
	db 98	; Secondary instrument (7). Note reference (2). Primary wait (0).
	db 169	; Secondary instrument (7). Note reference (9). Secondary wait (1).
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (7). New escaped note: 34. Primary wait (0).
	db 34	;   Escape note value.
	db 8	;    Pitch table effect 0.
	db 111	; Secondary instrument (7). Same escaped note: 34. Primary wait (0).
	db 175	; Secondary instrument (7). Same escaped note: 34. Secondary wait (1).
	db 111	; Secondary instrument (7). Same escaped note: 34. Primary wait (0).
	db 238	; Secondary instrument (7). New escaped note: 41. New wait (127).
	db 41	;   Escape note value.
	db 127	;   Escape wait value.

Lookool_Subsong0_Track9
	db 12	; Note with effects flag.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 0	;    Reset effect, with inverted volume: 0.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 75. Primary wait (0).
	db 75	;   Escape note value.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 38	;    Arpeggio table effect 2.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 0	;    Reset effect, with inverted volume: 0.
	db 24	; Primary instrument (5). Note reference (8). 
	db 94	; Primary instrument (5). New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 12	; Note with effects flag.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 54	;    Arpeggio table effect 3.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 0	;    Reset effect, with inverted volume: 0.
	db 17	; Primary instrument (5). Note reference (1). 
	db 94	; Primary instrument (5). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 86	; Primary instrument (5). Note reference (6). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 222	; Primary instrument (5). New escaped note: 58. New wait (127).
	db 58	;   Escape note value.
	db 127	;   Escape wait value.

Lookool_Subsong0_Track10
	db 12	; Note with effects flag.
	db 235	; Secondary instrument (7). Note reference (11). New wait (15).
	db 15	;   Escape wait value.
	db 0	;    Reset effect, with inverted volume: 0.
	db 238	; Secondary instrument (7). New escaped note: 20. New wait (7).
	db 20	;   Escape note value.
	db 7	;   Escape wait value.
	db 229	; Secondary instrument (7). Note reference (5). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track11
	db 171	; Secondary instrument (7). Note reference (11). Secondary wait (1).
	db 169	; Secondary instrument (7). Note reference (9). Secondary wait (1).
	db 105	; Secondary instrument (7). Note reference (9). Primary wait (0).
	db 99	; Secondary instrument (7). Note reference (3). Primary wait (0).
	db 103	; Secondary instrument (7). Note reference (7). Primary wait (0).
	db 162	; Secondary instrument (7). Note reference (2). Secondary wait (1).
	db 171	; Secondary instrument (7). Note reference (11). Secondary wait (1).
	db 107	; Secondary instrument (7). Note reference (11). Primary wait (0).
	db 110	; Secondary instrument (7). New escaped note: 20. Primary wait (0).
	db 20	;   Escape note value.
	db 101	; Secondary instrument (7). Note reference (5). Primary wait (0).
	db 98	; Secondary instrument (7). Note reference (2). Primary wait (0).
	db 47	; Secondary instrument (7). Same escaped note: 20. 
	db 110	; Secondary instrument (7). New escaped note: 32. Primary wait (0).
	db 32	;   Escape note value.
	db 99	; Secondary instrument (7). Note reference (3). Primary wait (0).
	db 98	; Secondary instrument (7). Note reference (2). Primary wait (0).
	db 46	; Secondary instrument (7). New escaped note: 20. 
	db 20	;   Escape note value.
	db 110	; Secondary instrument (7). New escaped note: 21. Primary wait (0).
	db 21	;   Escape note value.
	db 111	; Secondary instrument (7). Same escaped note: 21. Primary wait (0).
	db 111	; Secondary instrument (7). Same escaped note: 21. Primary wait (0).
	db 111	; Secondary instrument (7). Same escaped note: 21. Primary wait (0).
	db 101	; Secondary instrument (7). Note reference (5). Primary wait (0).
	db 101	; Secondary instrument (7). Note reference (5). Primary wait (0).
	db 110	; Secondary instrument (7). New escaped note: 23. Primary wait (0).
	db 23	;   Escape note value.
	db 226	; Secondary instrument (7). Note reference (2). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track12
	db 141	; Secondary wait (1).
	db 12	; Note with effects flag.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 48	;    Reset effect, with inverted volume: 3.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 75. Primary wait (0).
	db 75	;   Escape note value.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 38	;    Arpeggio table effect 2.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 48	;    Reset effect, with inverted volume: 3.
	db 24	; Primary instrument (5). Note reference (8). 
	db 94	; Primary instrument (5). New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 12	; Note with effects flag.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 54	;    Arpeggio table effect 3.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 48	;    Reset effect, with inverted volume: 3.
	db 17	; Primary instrument (5). Note reference (1). 
	db 94	; Primary instrument (5). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 209	; Primary instrument (5). Note reference (1). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track13
	db 12	; Note with effects flag.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 0	;    Reset effect, with inverted volume: 0.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 75. Primary wait (0).
	db 75	;   Escape note value.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 38	;    Arpeggio table effect 2.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 0	;    Reset effect, with inverted volume: 0.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 77. Primary wait (0).
	db 77	;   Escape note value.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 79. Primary wait (0).
	db 79	;   Escape note value.
	db 158	; Primary instrument (5). New escaped note: 77. Secondary wait (1).
	db 77	;   Escape note value.
	db 94	; Primary instrument (5). New escaped note: 81. Primary wait (0).
	db 81	;   Escape note value.
	db 94	; Primary instrument (5). New escaped note: 77. Primary wait (0).
	db 77	;   Escape note value.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 158	; Primary instrument (5). New escaped note: 69. Secondary wait (1).
	db 69	;   Escape note value.
	db 94	; Primary instrument (5). New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 216	; Primary instrument (5). Note reference (8). New wait (127).
	db 127	;   Escape wait value.

Lookool_Subsong0_Track14
	db 13
	db 12	; Note with effects flag.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 48	;    Reset effect, with inverted volume: 3.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 81	; Primary instrument (5). Note reference (1). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 90	; Primary instrument (5). Note reference (10). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 80	; Primary instrument (5). Note reference (0). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 75. Primary wait (0).
	db 75	;   Escape note value.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 38	;    Arpeggio table effect 2.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (5). New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 48	;    Reset effect, with inverted volume: 3.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 77. Primary wait (0).
	db 77	;   Escape note value.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 94	; Primary instrument (5). New escaped note: 79. Primary wait (0).
	db 79	;   Escape note value.
	db 158	; Primary instrument (5). New escaped note: 77. Secondary wait (1).
	db 77	;   Escape note value.
	db 94	; Primary instrument (5). New escaped note: 81. Primary wait (0).
	db 81	;   Escape note value.
	db 94	; Primary instrument (5). New escaped note: 77. Primary wait (0).
	db 77	;   Escape note value.
	db 88	; Primary instrument (5). Note reference (8). Primary wait (0).
	db 222	; Primary instrument (5). New escaped note: 69. New wait (127).
	db 69	;   Escape note value.
	db 127	;   Escape wait value.

Lookool_Subsong0DisarkByteRegionEnd5
; The note indexes.
Lookool_Subsong0_NoteIndexes
Lookool_Subsong0DisarkByteRegionStart6
	db 60	; Note for index 0.
	db 65	; Note for index 1.
	db 24	; Note for index 2.
	db 27	; Note for index 3.
	db 38	; Note for index 4.
	db 22	; Note for index 5.
	db 63	; Note for index 6.
	db 26	; Note for index 7.
	db 72	; Note for index 8.
	db 29	; Note for index 9.
	db 67	; Note for index 10.
	db 17	; Note for index 11.
Lookool_Subsong0DisarkByteRegionEnd6


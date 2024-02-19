; KROCKET2, Song part, encoded in the AKM (minimalist) format V0.


KROCKET2_Start
KROCKET2_StartDisarkGenerateExternalLabel

KROCKET2_DisarkPointerRegionStart0
	dw KROCKET2_InstrumentIndexes	; Index table for the Instruments.
KROCKET2_DisarkForceNonReferenceDuring2_1
	dw 0	; Index table for the Arpeggios.
KROCKET2_DisarkForceNonReferenceDuring2_2
	dw 0	; Index table for the Pitches.

; The subsongs references.
	dw KROCKET2_Subsong0
KROCKET2_DisarkPointerRegionEnd0

; The Instrument indexes.
KROCKET2_InstrumentIndexes
KROCKET2_DisarkPointerRegionStart3
	dw KROCKET2_Instrument0
	dw KROCKET2_Instrument1
	dw KROCKET2_Instrument2
	dw KROCKET2_Instrument3
	dw KROCKET2_Instrument4
	dw KROCKET2_Instrument5
	dw KROCKET2_Instrument6
	dw KROCKET2_Instrument7
	dw KROCKET2_Instrument8
	dw KROCKET2_Instrument9
	dw KROCKET2_Instrument10
	dw KROCKET2_Instrument11
KROCKET2_DisarkPointerRegionEnd3

; The Instrument.
KROCKET2_DisarkByteRegionStart4
KROCKET2_Instrument0
	db 255	; Speed.

KROCKET2_Instrument0Loop	db 0	; Volume: 0.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart5
	dw KROCKET2_Instrument0Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd5

KROCKET2_Instrument1
	db 1	; Speed.

	db 61	; Volume: 15.

	db 178, 12	; Arpeggio: 12.

	db 202, 12	; Arpeggio: 12.

	db 189	; Volume: 15.
	db 232	; Arpeggio: -12.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

KROCKET2_Instrument1Loop	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart6
	dw KROCKET2_Instrument1Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd6

KROCKET2_Instrument2
	db 0	; Speed.

KROCKET2_Instrument2Loop	db 248	; Volume: 15.
	db 1	; Noise.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart7
	dw KROCKET2_Instrument2Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd7

KROCKET2_Instrument3
	db 0	; Speed.

KROCKET2_Instrument3Loop	db 248	; Volume: 15.
	db 1	; Noise.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 240	; Volume: 14.
	db 1	; Noise.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart8
	dw KROCKET2_Instrument3Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd8

KROCKET2_Instrument4
	db 0	; Speed.

KROCKET2_Instrument4Loop	db 61	; Volume: 15.

	db 61	; Volume: 15.

	db 61	; Volume: 15.

	db 189	; Volume: 15.
	db 232	; Arpeggio: -12.

	db 189	; Volume: 15.
	db 232	; Arpeggio: -12.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart9
	dw KROCKET2_Instrument4Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd9

KROCKET2_Instrument5
	db 0	; Speed.

	db 189	; Volume: 15.
	db 24	; Arpeggio: 12.

KROCKET2_Instrument5Loop	db 61	; Volume: 15.

	db 125	; Volume: 15.
	dw -3	; Pitch: -3.

	db 61	; Volume: 15.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart10
	dw KROCKET2_Instrument5Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd10

KROCKET2_Instrument6
	db 0	; Speed.

KROCKET2_Instrument6Loop	db 248	; Volume: 15.
	db 16	; Noise.

	db 240	; Volume: 14.
	db 17	; Noise.

	db 232	; Volume: 13.
	db 18	; Noise.

	db 232	; Volume: 13.
	db 19	; Noise.

	db 232	; Volume: 13.
	db 20	; Noise.

	db 232	; Volume: 13.
	db 21	; Noise.

	db 232	; Volume: 13.
	db 22	; Noise.

	db 232	; Volume: 13.
	db 23	; Noise.

	db 232	; Volume: 13.
	db 24	; Noise.

	db 232	; Volume: 13.
	db 25	; Noise.

	db 232	; Volume: 13.
	db 26	; Noise.

	db 232	; Volume: 13.
	db 27	; Noise.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart11
	dw KROCKET2_Instrument6Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd11

KROCKET2_Instrument7
	db 0	; Speed.

KROCKET2_Instrument7Loop	db 248	; Volume: 15.
	db 1	; Noise.

	db 232	; Volume: 13.
	db 3	; Noise.

	db 208	; Volume: 10.
	db 6	; Noise.

	db 200	; Volume: 9.
	db 6	; Noise.

	db 192	; Volume: 8.
	db 6	; Noise.

	db 184	; Volume: 7.
	db 6	; Noise.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart12
	dw KROCKET2_Instrument7Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd12

KROCKET2_Instrument8
	db 0	; Speed.

	db 185	; Volume: 14.
	db 209	; Arpeggio: -24.
	db 15	; Noise: 15.

	db 173	; Volume: 11.
	db 209	; Arpeggio: -24.
	db 16	; Noise: 16.

	db 165	; Volume: 9.
	db 209	; Arpeggio: -24.
	db 18	; Noise: 18.

KROCKET2_Instrument8Loop	db 185	; Volume: 14.
	db 1	; Arpeggio: 0.
	db 20	; Noise: 20.

	db 185	; Volume: 14.
	db 1	; Arpeggio: 0.
	db 21	; Noise: 21.

	db 185	; Volume: 14.
	db 1	; Arpeggio: 0.
	db 23	; Noise: 23.

	db 185	; Volume: 14.
	db 233	; Arpeggio: -12.
	db 26	; Noise: 26.

	db 185	; Volume: 14.
	db 233	; Arpeggio: -12.
	db 30	; Noise: 30.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart13
	dw KROCKET2_Instrument8Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd13

KROCKET2_Instrument9
	db 0	; Speed.

KROCKET2_Instrument9Loop	db 61	; Volume: 15.

	db 121	; Volume: 14.
	dw -3	; Pitch: -3.

	db 117	; Volume: 13.
	dw 3	; Pitch: 3.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart14
	dw KROCKET2_Instrument9Loop	; Loops.
KROCKET2_DisarkPointerRegionEnd14

KROCKET2_Instrument10
	db 0	; Speed.

	db 248	; Volume: 15.
	db 19	; Noise.

	db 240	; Volume: 14.
	db 4	; Noise.

	db 232	; Volume: 13.
	db 5	; Noise.

	db 232	; Volume: 13.
	db 7	; Noise.

	db 232	; Volume: 13.
	db 9	; Noise.

	db 232	; Volume: 13.
	db 10	; Noise.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart15
	dw KROCKET2_Instrument0Loop	; Loop to silence.
KROCKET2_DisarkPointerRegionEnd15

KROCKET2_Instrument11
	db 0	; Speed.

	db 189	; Volume: 15.
	db 1	; Arpeggio: 0.
	db 30	; Noise: 30.

	db 240	; Volume: 14.
	db 13	; Noise.

	db 232	; Volume: 13.
	db 19	; Noise.

	db 233	; Volume: 10.
	db 1	; Arpeggio: 0.
	db 14	; Noise: 14.
	dw 11	; Pitch: 11.

	db 200	; Volume: 9.
	db 9	; Noise.

	db 4	; End the instrument.
KROCKET2_DisarkPointerRegionStart16
	dw KROCKET2_Instrument0Loop	; Loop to silence.
KROCKET2_DisarkPointerRegionEnd16

KROCKET2_DisarkByteRegionEnd4
KROCKET2_ArpeggioIndexes
KROCKET2_DisarkPointerRegionStart17
KROCKET2_DisarkPointerRegionEnd17

KROCKET2_DisarkByteRegionStart18
KROCKET2_DisarkByteRegionEnd18

KROCKET2_PitchIndexes
KROCKET2_DisarkPointerRegionStart19
KROCKET2_DisarkPointerRegionEnd19

KROCKET2_DisarkByteRegionStart20
KROCKET2_DisarkByteRegionEnd20

; KROCKET2, Subsong 0.
; ----------------------------------

KROCKET2_Subsong0
KROCKET2_Subsong0DisarkPointerRegionStart0
	dw KROCKET2_Subsong0_NoteIndexes	; Index table for the notes.
	dw KROCKET2_Subsong0_TrackIndexes	; Index table for the Tracks.
KROCKET2_Subsong0DisarkPointerRegionEnd0

KROCKET2_Subsong0DisarkByteRegionStart1
	db 6	; Initial speed.

	db 9	; Most used instrument.
	db 1	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

	db 74	; Default start note in tracks.
	db 6	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
KROCKET2_Subsong0DisarkByteRegionEnd1

; The Linker.
KROCKET2_Subsong0DisarkByteRegionStart2
; Pattern 0
KROCKET2_Subsong0_Loop
	db 170	; State byte.
	db 13	; New height.
	db 137	; New track (0) for channel 1, as a reference (index 9).
	db 138	; New track (1) for channel 2, as a reference (index 10).
	db 133	; New track (2) for channel 3, as a reference (index 5).

; Pattern 1
	db 0	; State byte.

; Pattern 2
	db 0	; State byte.

; Pattern 3
	db 0	; State byte.

; Pattern 4
	db 20	; State byte.
	db -2	; New transposition on channel 1.
	db -2	; New transposition on channel 2.

; Pattern 5
	db 20	; State byte.
	db -3	; New transposition on channel 1.
	db -3	; New transposition on channel 2.

; Pattern 6
	db 188	; State byte.
	db 0	; New transposition on channel 1.
	db 131	; New track (4) for channel 1, as a reference (index 3).
	db 0	; New transposition on channel 2.
	db 128	; New track (5) for channel 2, as a reference (index 0).
	db 129	; New track (3) for channel 3, as a reference (index 1).

; Pattern 7
	db 16	; State byte.
	db 12	; New transposition on channel 2.

; Pattern 8
	db 16	; State byte.
	db 0	; New transposition on channel 2.

; Pattern 9
	db 16	; State byte.
	db 12	; New transposition on channel 2.

; Pattern 10
	db 20	; State byte.
	db -2	; New transposition on channel 1.
	db -2	; New transposition on channel 2.

; Pattern 11
	db 20	; State byte.
	db -3	; New transposition on channel 1.
	db -3	; New transposition on channel 2.

; Pattern 12
	db 20	; State byte.
	db 0	; New transposition on channel 1.
	db 0	; New transposition on channel 2.

; Pattern 13
	db 16	; State byte.
	db 12	; New transposition on channel 2.

; Pattern 14
	db 16	; State byte.
	db 4	; New transposition on channel 2.

; Pattern 15
	db 18	; State byte.
	db 11	; New height.
	db 3	; New transposition on channel 2.

; Pattern 16
	db 186	; State byte.
	db 3	; New height.
	db ((KROCKET2_Subsong0_Track12 - ($ + 2)) & #ff00) / 256	; New track (12) for channel 1, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track12 - ($ + 1)) & 255)
	db 0	; New transposition on channel 2.
	db 133	; New track (2) for channel 2, as a reference (index 5).
	db ((KROCKET2_Subsong0_Track13 - ($ + 2)) & #ff00) / 256	; New track (13) for channel 3, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track13 - ($ + 1)) & 255)

; Pattern 17
	db 170	; State byte.
	db 15	; New height.
	db 143	; New track (6) for channel 1, as a reference (index 15).
	db 141	; New track (7) for channel 2, as a reference (index 13).
	db 142	; New track (8) for channel 3, as a reference (index 14).

; Pattern 18
	db 0	; State byte.

; Pattern 19
	db 0	; State byte.

; Pattern 20
	db 0	; State byte.

; Pattern 21
	db 168	; State byte.
	db 136	; New track (10) for channel 1, as a reference (index 8).
	db 134	; New track (11) for channel 2, as a reference (index 6).
	db 135	; New track (9) for channel 3, as a reference (index 7).

; Pattern 22
	db 64	; State byte.
	db -1	; New transposition on channel 3.

; Pattern 23
	db 64	; State byte.
	db -2	; New transposition on channel 3.

; Pattern 24
	db 64	; State byte.
	db -1	; New transposition on channel 3.

; Pattern 25
	db 64	; State byte.
	db 0	; New transposition on channel 3.

; Pattern 26
	db 66	; State byte.
	db 7	; New height.
	db 1	; New transposition on channel 3.

; Pattern 27
	db 64	; State byte.
	db 2	; New transposition on channel 3.

; Pattern 28
	db 234	; State byte.
	db 3	; New height.
	db ((KROCKET2_Subsong0_Track12 - ($ + 2)) & #ff00) / 256	; New track (12) for channel 1, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track12 - ($ + 1)) & 255)
	db 133	; New track (2) for channel 2, as a reference (index 5).
	db 0	; New transposition on channel 3.
	db ((KROCKET2_Subsong0_Track13 - ($ + 2)) & #ff00) / 256	; New track (13) for channel 3, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track13 - ($ + 1)) & 255)

; Pattern 29
	db 170	; State byte.
	db 13	; New height.
	db 130	; New track (15) for channel 1, as a reference (index 2).
	db 128	; New track (5) for channel 2, as a reference (index 0).
	db 129	; New track (3) for channel 3, as a reference (index 1).

; Pattern 30
	db 16	; State byte.
	db 7	; New transposition on channel 2.

; Pattern 31
	db 16	; State byte.
	db 3	; New transposition on channel 2.

; Pattern 32
	db 16	; State byte.
	db 5	; New transposition on channel 2.

; Pattern 33
	db 20	; State byte.
	db 12	; New transposition on channel 1.
	db 0	; New transposition on channel 2.

; Pattern 34
	db 16	; State byte.
	db 7	; New transposition on channel 2.

; Pattern 35
	db 16	; State byte.
	db 10	; New transposition on channel 2.

; Pattern 36
	db 18	; State byte.
	db 11	; New height.
	db 5	; New transposition on channel 2.

; Pattern 37
	db 18	; State byte.
	db 3	; New height.
	db 7	; New transposition on channel 2.

; Pattern 38
	db 30	; State byte.
	db 13	; New height.
	db 0	; New transposition on channel 1.
	db 132	; New track (16) for channel 1, as a reference (index 4).
	db 0	; New transposition on channel 2.

; Pattern 39
	db 16	; State byte.
	db 7	; New transposition on channel 2.

; Pattern 40
	db 16	; State byte.
	db 3	; New transposition on channel 2.

; Pattern 41
	db 16	; State byte.
	db 5	; New transposition on channel 2.

; Pattern 42
	db 16	; State byte.
	db 0	; New transposition on channel 2.

; Pattern 43
	db 16	; State byte.
	db 7	; New transposition on channel 2.

; Pattern 44
	db 16	; State byte.
	db 10	; New transposition on channel 2.

; Pattern 45
	db 16	; State byte.
	db 9	; New transposition on channel 2.

; Pattern 46
	db 28	; State byte.
	db 12	; New transposition on channel 1.
	db 130	; New track (15) for channel 1, as a reference (index 2).
	db 8	; New transposition on channel 2.

; Pattern 47
	db 0	; State byte.

; Pattern 48
	db 8	; State byte.
	db 132	; New track (16) for channel 1, as a reference (index 4).

; Pattern 49
	db 2	; State byte.
	db 7	; New height.

; Pattern 50
	db 26	; State byte.
	db 3	; New height.
	db 130	; New track (15) for channel 1, as a reference (index 2).
	db 5	; New transposition on channel 2.

; Pattern 51
	db 16	; State byte.
	db 7	; New transposition on channel 2.

; Pattern 52
	db 158	; State byte.
	db 15	; New height.
	db 0	; New transposition on channel 1.
	db 139	; New track (14) for channel 1, as a reference (index 11).
	db 0	; New transposition on channel 2.
	db 140	; New track (17) for channel 3, as a reference (index 12).

; Pattern 53
	db 2	; State byte.
	db 7	; New height.

; Pattern 54
	db 168	; State byte.
	db ((KROCKET2_Subsong0_Track18 - ($ + 2)) & #ff00) / 256	; New track (18) for channel 1, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track18 - ($ + 1)) & 255)
	db 144	; New track (19) for channel 2, as a reference (index 16).
	db ((KROCKET2_Subsong0_Track20 - ($ + 2)) & #ff00) / 256	; New track (20) for channel 3, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track20 - ($ + 1)) & 255)

; Pattern 55
	db 170	; State byte.
	db 15	; New height.
	db 139	; New track (14) for channel 1, as a reference (index 11).
	db 128	; New track (5) for channel 2, as a reference (index 0).
	db 140	; New track (17) for channel 3, as a reference (index 12).

; Pattern 56
	db 2	; State byte.
	db 7	; New height.

; Pattern 57
	db 168	; State byte.
	db ((KROCKET2_Subsong0_Track18 - ($ + 2)) & #ff00) / 256	; New track (18) for channel 1, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track18 - ($ + 1)) & 255)
	db 144	; New track (19) for channel 2, as a reference (index 16).
	db ((KROCKET2_Subsong0_Track20 - ($ + 2)) & #ff00) / 256	; New track (20) for channel 3, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track20 - ($ + 1)) & 255)

; Pattern 58
	db 168	; State byte.
	db 139	; New track (14) for channel 1, as a reference (index 11).
	db 128	; New track (5) for channel 2, as a reference (index 0).
	db 140	; New track (17) for channel 3, as a reference (index 12).

; Pattern 59
	db 168	; State byte.
	db ((KROCKET2_Subsong0_Track21 - ($ + 2)) & #ff00) / 256	; New track (21) for channel 1, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track21 - ($ + 1)) & 255)
	db 144	; New track (19) for channel 2, as a reference (index 16).
	db ((KROCKET2_Subsong0_Track22 - ($ + 2)) & #ff00) / 256	; New track (22) for channel 3, as an offset. Offset MSB, then LSB.
	db ((KROCKET2_Subsong0_Track22 - ($ + 1)) & 255)

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
KROCKET2_Subsong0DisarkByteRegionEnd2
KROCKET2_Subsong0DisarkPointerRegionStart3
	dw KROCKET2_Subsong0_Loop

KROCKET2_Subsong0DisarkPointerRegionEnd3
; The indexes of the tracks.
KROCKET2_Subsong0_TrackIndexes
KROCKET2_Subsong0DisarkPointerRegionStart4
	dw KROCKET2_Subsong0_Track5	; Track 5, index 0.
	dw KROCKET2_Subsong0_Track3	; Track 3, index 1.
	dw KROCKET2_Subsong0_Track15	; Track 15, index 2.
	dw KROCKET2_Subsong0_Track4	; Track 4, index 3.
	dw KROCKET2_Subsong0_Track16	; Track 16, index 4.
	dw KROCKET2_Subsong0_Track2	; Track 2, index 5.
	dw KROCKET2_Subsong0_Track11	; Track 11, index 6.
	dw KROCKET2_Subsong0_Track9	; Track 9, index 7.
	dw KROCKET2_Subsong0_Track10	; Track 10, index 8.
	dw KROCKET2_Subsong0_Track0	; Track 0, index 9.
	dw KROCKET2_Subsong0_Track1	; Track 1, index 10.
	dw KROCKET2_Subsong0_Track14	; Track 14, index 11.
	dw KROCKET2_Subsong0_Track17	; Track 17, index 12.
	dw KROCKET2_Subsong0_Track7	; Track 7, index 13.
	dw KROCKET2_Subsong0_Track8	; Track 8, index 14.
	dw KROCKET2_Subsong0_Track6	; Track 6, index 15.
	dw KROCKET2_Subsong0_Track19	; Track 19, index 16.
KROCKET2_Subsong0DisarkPointerRegionEnd4

KROCKET2_Subsong0DisarkByteRegionStart5
KROCKET2_Subsong0_Track0
	db 12	; Note with effects flag.
	db 224	; Secondary instrument (1). Note reference (0). New wait (2).
	db 2	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 224	; Secondary instrument (1). Note reference (0). New wait (3).
	db 3	;   Escape wait value.
	db 224	; Secondary instrument (1). Note reference (0). New wait (2).
	db 2	;   Escape wait value.
	db 228	; Secondary instrument (1). Note reference (4). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track1
	db 190	; New instrument (0). New escaped note: 48. Secondary wait (1).
	db 48	;   Escape note value.
	db 0	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 224	; Secondary instrument (1). Note reference (0). New wait (2).
	db 2	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 32	; Secondary instrument (1). Note reference (0). 
	db 224	; Secondary instrument (1). Note reference (0). New wait (3).
	db 3	;   Escape wait value.
	db 229	; Secondary instrument (1). Note reference (5). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track2
	db 254	; New instrument (0). New escaped note: 48. New wait (127).
	db 48	;   Escape note value.
	db 0	;   Escape instrument value.
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track3
	db 12	; Note with effects flag.
	db 113	; New instrument (11). Note reference (1). Primary wait (0).
	db 11	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 177	; New instrument (2). Note reference (1). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 113	; New instrument (11). Note reference (1). Primary wait (0).
	db 11	;   Escape instrument value.
	db 126	; New instrument (10). New escaped note: 69. Primary wait (0).
	db 69	;   Escape note value.
	db 10	;   Escape instrument value.
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 113	; New instrument (11). Note reference (1). Primary wait (0).
	db 11	;   Escape instrument value.
	db 65	; Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 113	; New instrument (11). Note reference (1). Primary wait (0).
	db 11	;   Escape instrument value.
	db 65	; Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 127	; New instrument (10). Same escaped note: 69. Primary wait (0).
	db 10	;   Escape instrument value.
	db 241	; New instrument (3). Note reference (1). New wait (127).
	db 3	;   Escape instrument value.
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track4
	db 12	; Note with effects flag.
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 96	; Secondary instrument (1). Note reference (0). Primary wait (0).
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 96	; Secondary instrument (1). Note reference (0). Primary wait (0).
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 164	; Secondary instrument (1). Note reference (4). Secondary wait (1).
	db 229	; Secondary instrument (1). Note reference (5). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track5
	db 12	; Note with effects flag.
	db 241	; New instrument (4). Note reference (1). New wait (127).
	db 4	;   Escape instrument value.
	db 127	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.

KROCKET2_Subsong0_Track6
	db 12	; Note with effects flag.
	db 127	; New instrument (5). Same escaped note: 74. Primary wait (0).
	db 5	;   Escape instrument value.
	db 50	;    Volume effect, with inverted volume: 3.
	db 78	; New escaped note: 72. Primary wait (0).
	db 72	;   Escape note value.
	db 78	; New escaped note: 71. Primary wait (0).
	db 71	;   Escape note value.
	db 78	; New escaped note: 67. Primary wait (0).
	db 67	;   Escape note value.
	db 78	; New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 78	; New escaped note: 72. Primary wait (0).
	db 72	;   Escape note value.
	db 78	; New escaped note: 71. Primary wait (0).
	db 71	;   Escape note value.
	db 78	; New escaped note: 67. Primary wait (0).
	db 67	;   Escape note value.
	db 78	; New escaped note: 65. Primary wait (0).
	db 65	;   Escape note value.
	db 71	; Note reference (7). Primary wait (0).
	db 78	; New escaped note: 60. Primary wait (0).
	db 60	;   Escape note value.
	db 74	; Note reference (10). Primary wait (0).
	db 73	; Note reference (9). Primary wait (0).
	db 78	; New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 74	; Note reference (10). Primary wait (0).
	db 199	; Note reference (7). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track7
	db 12	; Note with effects flag.
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 90	; Primary instrument (9). Note reference (10). Primary wait (0).
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 154	; Primary instrument (9). Note reference (10). Secondary wait (1).
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 90	; Primary instrument (9). Note reference (10). Primary wait (0).
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 217	; Primary instrument (9). Note reference (9). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track8
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 245	; New instrument (4). Note reference (5). New wait (5).
	db 4	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 240	; New instrument (7). Note reference (0). New wait (3).
	db 7	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 254	; New instrument (8). New escaped note: 41. New wait (127).
	db 41	;   Escape note value.
	db 8	;   Escape instrument value.
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track9
	db 192	; Note reference (0). New wait (3).
	db 3	;   Escape wait value.
	db 254	; New instrument (4). New escaped note: 39. New wait (5).
	db 39	;   Escape note value.
	db 4	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 121	; New instrument (7). Note reference (9). Primary wait (0).
	db 7	;   Escape instrument value.
	db 191	; New instrument (4). Same escaped note: 39. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 121	; New instrument (7). Note reference (9). Primary wait (0).
	db 7	;   Escape instrument value.
	db 255	; New instrument (4). Same escaped note: 39. New wait (127).
	db 4	;   Escape instrument value.
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track10
	db 12	; Note with effects flag.
	db 127	; New instrument (5). Same escaped note: 74. Primary wait (0).
	db 5	;   Escape instrument value.
	db 50	;    Volume effect, with inverted volume: 3.
	db 78	; New escaped note: 72. Primary wait (0).
	db 72	;   Escape note value.
	db 78	; New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 78	; New escaped note: 67. Primary wait (0).
	db 67	;   Escape note value.
	db 78	; New escaped note: 74. Primary wait (0).
	db 74	;   Escape note value.
	db 78	; New escaped note: 72. Primary wait (0).
	db 72	;   Escape note value.
	db 78	; New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 78	; New escaped note: 67. Primary wait (0).
	db 67	;   Escape note value.
	db 78	; New escaped note: 65. Primary wait (0).
	db 65	;   Escape note value.
	db 71	; Note reference (7). Primary wait (0).
	db 78	; New escaped note: 60. Primary wait (0).
	db 60	;   Escape note value.
	db 72	; Note reference (8). Primary wait (0).
	db 64	; Note reference (0). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 72	; Note reference (8). Primary wait (0).
	db 207	; Same escaped note: 60. New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track11
	db 12	; Note with effects flag.
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 88	; Primary instrument (9). Note reference (8). Primary wait (0).
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 152	; Primary instrument (9). Note reference (8). Secondary wait (1).
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 88	; Primary instrument (9). Note reference (8). Primary wait (0).
	db 80	; Primary instrument (9). Note reference (0). Primary wait (0).
	db 82	; Primary instrument (9). Note reference (2). Primary wait (0).
	db 216	; Primary instrument (9). Note reference (8). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track12
	db 12	; Note with effects flag.
	db 107	; Secondary instrument (1). Note reference (11). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 105	; Secondary instrument (1). Note reference (9). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (1). New escaped note: 54. Primary wait (0).
	db 54	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 224	; Secondary instrument (1). Note reference (0). New wait (127).
	db 127	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.

KROCKET2_Subsong0_Track13
	db 12	; Note with effects flag.
	db 115	; New instrument (4). Note reference (3). Primary wait (0).
	db 4	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 29. Primary wait (0).
	db 29	;   Escape note value.
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 30. Primary wait (0).
	db 30	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 193	; Note reference (1). New wait (127).
	db 127	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.

KROCKET2_Subsong0_Track14
	db 145	; Primary instrument (9). Note reference (1). Secondary wait (1).
	db 157	; Effect only. Secondary wait (1).
	db 244	;    Pitch down: 512.
	db 0	;    Pitch, LSB.
	db 2	;    Pitch, MSB.
	db 158	; Primary instrument (9). New escaped note: 19. Secondary wait (1).
	db 19	;   Escape note value.
	db 145	; Primary instrument (9). Note reference (1). Secondary wait (1).
	db 145	; Primary instrument (9). Note reference (1). Secondary wait (1).
	db 157	; Effect only. Secondary wait (1).
	db 244	;    Pitch down: 512.
	db 0	;    Pitch, LSB.
	db 2	;    Pitch, MSB.
	db 159	; Primary instrument (9). Same escaped note: 19. Secondary wait (1).
	db 209	; Primary instrument (9). Note reference (1). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track15
	db 12	; Note with effects flag.
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 100	; Secondary instrument (1). Note reference (4). Primary wait (0).
	db 165	; Secondary instrument (1). Note reference (5). Secondary wait (1).
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 100	; Secondary instrument (1). Note reference (4). Primary wait (0).
	db 165	; Secondary instrument (1). Note reference (5). Secondary wait (1).
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 100	; Secondary instrument (1). Note reference (4). Primary wait (0).
	db 229	; Secondary instrument (1). Note reference (5). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track16
	db 164	; Secondary instrument (1). Note reference (4). Secondary wait (1).
	db 103	; Secondary instrument (1). Note reference (7). Primary wait (0).
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 164	; Secondary instrument (1). Note reference (4). Secondary wait (1).
	db 103	; Secondary instrument (1). Note reference (7). Primary wait (0).
	db 160	; Secondary instrument (1). Note reference (0). Secondary wait (1).
	db 164	; Secondary instrument (1). Note reference (4). Secondary wait (1).
	db 103	; Secondary instrument (1). Note reference (7). Primary wait (0).
	db 224	; Secondary instrument (1). Note reference (0). New wait (127).
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track17
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 181	; New instrument (4). Note reference (5). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 240	; New instrument (6). Note reference (0). New wait (3).
	db 6	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 123	; New instrument (10). Note reference (11). Primary wait (0).
	db 10	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 75	; Note reference (11). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 75	; Note reference (11). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 75	; Note reference (11). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (6). Note reference (0). Secondary wait (1).
	db 6	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.
	db 34	;    Volume effect, with inverted volume: 2.

KROCKET2_Subsong0_Track18
	db 145	; Primary instrument (9). Note reference (1). Secondary wait (1).
	db 158	; Primary instrument (9). New escaped note: 33. Secondary wait (1).
	db 33	;   Escape note value.
	db 158	; Primary instrument (9). New escaped note: 34. Secondary wait (1).
	db 34	;   Escape note value.
	db 222	; Primary instrument (9). New escaped note: 36. New wait (127).
	db 36	;   Escape note value.
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track19
	db 177	; New instrument (4). Note reference (1). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 142	; New escaped note: 33. Secondary wait (1).
	db 33	;   Escape note value.
	db 142	; New escaped note: 34. Secondary wait (1).
	db 34	;   Escape note value.
	db 206	; New escaped note: 36. New wait (127).
	db 36	;   Escape note value.
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track20
	db 12	; Note with effects flag.
	db 115	; New instrument (10). Note reference (3). Primary wait (0).
	db 10	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 115	; New instrument (11). Note reference (3). Primary wait (0).
	db 11	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 115	; New instrument (10). Note reference (3). Primary wait (0).
	db 10	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 195	; Note reference (3). New wait (127).
	db 127	;   Escape wait value.
	db 50	;    Volume effect, with inverted volume: 3.

KROCKET2_Subsong0_Track21
	db 158	; Primary instrument (9). New escaped note: 34. Secondary wait (1).
	db 34	;   Escape note value.
	db 158	; Primary instrument (9). New escaped note: 36. Secondary wait (1).
	db 36	;   Escape note value.
	db 158	; Primary instrument (9). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 222	; Primary instrument (9). New escaped note: 41. New wait (127).
	db 41	;   Escape note value.
	db 127	;   Escape wait value.

KROCKET2_Subsong0_Track22
	db 12	; Note with effects flag.
	db 118	; New instrument (10). Note reference (6). Primary wait (0).
	db 10	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 198	; Note reference (6). New wait (127).
	db 127	;   Escape wait value.
	db 82	;    Volume effect, with inverted volume: 5.

KROCKET2_Subsong0DisarkByteRegionEnd5
; The note indexes.
KROCKET2_Subsong0_NoteIndexes
KROCKET2_Subsong0DisarkByteRegionStart6
	db 55	; Note for index 0.
	db 31	; Note for index 1.
	db 57	; Note for index 2.
	db 28	; Note for index 3.
	db 50	; Note for index 4.
	db 43	; Note for index 5.
	db 76	; Note for index 6.
	db 62	; Note for index 7.
	db 58	; Note for index 8.
	db 53	; Note for index 9.
	db 59	; Note for index 10.
	db 52	; Note for index 11.
KROCKET2_Subsong0DisarkByteRegionEnd6


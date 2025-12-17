function midi_instruments() {
	// midi_instruments()
	// https://en.wikipedia.org/wiki/General_MIDI#Program_change_events
	// https://jazz-soft.net/demo/GeneralMidi.html
	// https://minecraft.wiki/w/Note_Block#Instruments
	// https://openmidiproject.opal.ne.jp/documentations_en.html
	// Mapping contributed by u3002 (v2025-12-16)
	// https://gist.github.com/u3002/cf4daa83bc82b5917fc86fb23815578a
	var a;
	a = 0

	/*
	0 = name
	1 = instruments:
	   0  = Harp
	   1  = Double Bass
	   2  = Bass Drum
	   3  = Snare Drum
	   4  = Click
	   5  = Guitar
	   6  = Flute
	   7  = Bell
	   8  = Chime
	   9  = Xylophone
	   10 = Iron Xylophone
	   11 = Cow Bell
	   12 = Didgeridoo
	   13 = Bit
	   14 = Banjo
	   15 = Pling
	2 = octave difference
	   0  Harp                        | 0   | 47 Orchestral Harp
	   1  Bass (String Bass)          | +2  | 33 Acoustic Bass
	   2  Bass Drum (Kick)            | *0* | *117*
	   3  Snare Drum                  | *0* | *118*
	   4  Clicks and Sticks (Hi-hat)  | *0* | *116*
	   5  Guitar                      | +1  | 25 Acoustic Guitar (nylon)
	   6  Flute                       | -1  | 74 Flute
	   7  Bells (Glockenspiel)        | -2  | 10 Glockenspiel
	   8  Chimes                      | -2  | 113 Tinkle Bell
	   9  Xylophone                   | -2  | 14 Xylophone
	   10 Iron Xylophone (Vibraphone) | 0   | 12 Vibraphone
	   11 Cow Bell                    | -1  | 114 Agogo
	   12 Didgeridoo                  | +2  | 59 Tuba
	   13 Bit (Synthesizer)           | 0   | 81 Lead 1 (square)
	   14 Banjo                       | 0   | 106 Banjo
	   15 Pling (Electric piano)      | 0   | 3 Electric Grand Piano
	3 = shortened name (optional)
	*/

	// Piano
	midi_ins[a, 0] = "Acoustic Grand Piano" midi_ins[a, 3] = "Piano 1"
	midi_ins[a, 1] = 0 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Bright Acoustic Piano" midi_ins[a, 3] = "Piano 2"
	midi_ins[a, 1] = 15 midi_ins[a, 2] = 0 a += 1 
	midi_ins[a, 0] = "Electric Grand Piano" midi_ins[a, 3] = "Piano 3"
	midi_ins[a, 1] = 15 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Honky-tonk Piano" midi_ins[a, 3] = "Honky-tonk"
	midi_ins[a, 1] = 15 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Electric Piano 1" midi_ins[a, 3] = "E.Piano 1"
	midi_ins[a, 1] = 0 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Electric Piano 2" midi_ins[a, 3] = "E.Piano 2"
	midi_ins[a, 1] = 0 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Harpsichord" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Clavinet" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 14 midi_ins[a, 2] = 0 a += 1
	// Chromatic Percussion
	midi_ins[a, 0] = "Celesta" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 7 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Glockenspiel" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 7 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Music Box" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 7 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Vibraphone" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 10 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Marimba" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 10 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Xylophone" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 9 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Tubular Bells" midi_ins[a, 3] = "TubularBells"
	midi_ins[a, 1] = 7 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Dulcimer" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	// Organ
	midi_ins[a, 0] = "Drawbar Organ" midi_ins[a, 3] = "Organ 1"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Percussive Organ" midi_ins[a, 3] = "Organ 2"
	midi_ins[a, 1] = 10 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Rock Organ" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Church Organ" midi_ins[a, 3] = "ChurchOrgan"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Reed Organ" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Accordion" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Harmonica" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Bandoneon" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	// Guitar
	midi_ins[a, 0] = "Acoustic Guitar (nylon)" midi_ins[a, 3] = "Nylon-str.Gt"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Acoustic Guitar (steel)" midi_ins[a, 3] = "Steel-str.Gt"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Electric Guitar (jazz)" midi_ins[a, 3] = "Jazz Guitar"
	midi_ins[a, 1] = 0 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Electric Guitar (clean)" midi_ins[a, 3] = "Clean Guitar"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Electric Guitar (muted)" midi_ins[a, 3] = "Muted Guitar"
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Overdriven Guitar" midi_ins[a, 3] = "Overdrive Gt"
	midi_ins[a, 1] = 12 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Distortion Guitar" midi_ins[a, 3] = "DistortionGt"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Guitar Harmonics" midi_ins[a, 3] = "Gt.Harmonics"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 3 a += 1
	// Bass
	midi_ins[a, 0] = "Acoustic Bass" midi_ins[a, 3] = "AcousticBass"
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Electric Bass (finger)" midi_ins[a, 3] = "FingeredBass"
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Electric Bass (pick)" midi_ins[a, 3] = "Picked Bass"
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Fretless Bass" midi_ins[a, 3] = "FretlessBass"
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Slap Bass 1" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Slap Bass 2" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Synth Bass 1" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Synth Bass 2" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 15 midi_ins[a, 2] = 0 a += 1
	// Strings
	midi_ins[a, 0] = "Violin" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Viola" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Cello" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 12 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Contrabass" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 12 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Tremolo Strings" midi_ins[a, 3] = "Tremolo Str."
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pizzicato Strings" midi_ins[a, 3] = "Pizzicato"
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Orchestral Harp" midi_ins[a, 3] = "Harp"
	midi_ins[a, 1] = 0 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Timpani" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 3 midi_ins[a, 2] = 0 a += 1
	// Ensemble
	midi_ins[a, 0] = "String Ensemble 1" midi_ins[a, 3] = "Strings 1"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "String Ensemble 2" midi_ins[a, 3] = "Strings 2"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Synth Strings 1" midi_ins[a, 3] = "Syn.Strings1"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Synth Strings 2" midi_ins[a, 3] = "Syn.Strings2"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Choir Aahs" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Voice Oohs" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Synth Voice" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Orchestra Hit" midi_ins[a, 3] = "OrchestraHit"
	midi_ins[a, 1] = 3 midi_ins[a, 2] = 0 a += 1
	// Brass
	midi_ins[a, 0] = "Trumpet" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Trombone" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 12 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Tuba" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 12 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Muted Trumpet" midi_ins[a, 3] = "Muted Tp."
	midi_ins[a, 1] = 12 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "French Horn" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Brass Section" midi_ins[a, 3] = "Brass"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Synth Brass 1" midi_ins[a, 3] = "Synth Brass1"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Synth Brass 2" midi_ins[a, 3] = "Synth Brass2"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	// Reed
	midi_ins[a, 0] = "Soprano Sax" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Alto Sax" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Tenor Sax" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Baritone Sax" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Oboe" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "English Horn" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Bassoon" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Clarinet" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	// Pipe
	midi_ins[a, 0] = "Piccolo" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Flute" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Recorder" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pan Flute" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Blown Bottle" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Shakuhachi" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Whistle" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Ocarina" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	// Synth Lead
	midi_ins[a, 0] = "Lead 1 (square)" midi_ins[a, 3] = "Square Lead"
	midi_ins[a, 1] = 13 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Lead 2 (sawtooth)" midi_ins[a, 3] = "Saw Lead"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Lead 3 (calliope)" midi_ins[a, 3] = "Calliope"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Lead 4 (chiff)" midi_ins[a, 3] = "Chiff Lead"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Lead 5 (charang)" midi_ins[a, 3] = "Charang"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Lead 6 (voice)" midi_ins[a, 3] = "Voice Lead"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Lead 7 (fifths)" midi_ins[a, 3] = "Fifth Lead"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Lead 8 (bass + lead)" midi_ins[a, 3] = "Bass+Lead"
	midi_ins[a, 1] = 1 midi_ins[a, 2] = 2 a += 1
	// Synth Pad
	midi_ins[a, 0] = "Pad 1 (new age)" midi_ins[a, 3] = "Fantasia"
	midi_ins[a, 1] = 7 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Pad 2 (warm)" midi_ins[a, 3] = "Warm Pad"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pad 3 (polysynth)" midi_ins[a, 3] = "Polysynth"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pad 4 (choir)" midi_ins[a, 3] = "Space Choir"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pad 5 (bowed)" midi_ins[a, 3] = "Bowed Glass"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pad 6 (metallic)" midi_ins[a, 3] = "Metal Pad"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pad 7 (halo)" midi_ins[a, 3] = "Halo Pad"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Pad 8 (sweep)" midi_ins[a, 3] = "Sweep Pad"
	midi_ins[a, 1] = 8 midi_ins[a, 2] = -2 a += 1
	// Synth Effects
	midi_ins[a, 0] = "FX 1 (rain)" midi_ins[a, 3] = "Rain Drop"
	midi_ins[a, 1] = 8 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "FX 2 (soundtrack)" midi_ins[a, 3] = "Soundtrack"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "FX 3 (crystal)" midi_ins[a, 3] = "Crystal"
	midi_ins[a, 1] = 8 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "FX 4 (atmosphere)" midi_ins[a, 3] = "Atmosphere"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "FX 5 (brightness)" midi_ins[a, 3] = "Brightness"
	midi_ins[a, 1] = 15 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "FX 6 (goblins)" midi_ins[a, 3] = "Goblins"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "FX 7 (echoes)" midi_ins[a, 3] = "Echoes"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "FX 8 (sci-fi)" midi_ins[a, 3] = "SF"
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	// Ethnic
	midi_ins[a, 0] = "Sitar" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 14 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Banjo" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 14 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Shamisen" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 14 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Koto" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 5 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Kalimba" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 10 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Bag pipe" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Fiddle" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Shanai" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	// Percussive
	midi_ins[a, 0] = "Tinkle Bell" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 8 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Agogo" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 11 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Steel Drums" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 10 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Woodblock" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 9 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Taiko Drum" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 2 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Melodic Tom" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 2 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Synth Drum" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 2 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Reverse Cymbal" midi_ins[a, 3] = "Reverse Cym."
	midi_ins[a, 1] = 3 midi_ins[a, 2] = 0 a += 1
	// Sound Effects
	midi_ins[a, 0] = "Guitar Fret Noise" midi_ins[a, 3] = "Gt FretNoise"
	midi_ins[a, 1] = 4 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Breath Noise" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 6 midi_ins[a, 2] = -1 a += 1
	midi_ins[a, 0] = "Seashore" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 8 midi_ins[a, 2] = -2 a += 1
	midi_ins[a, 0] = "Bird Tweet" midi_ins[a, 3] = "Bird"
	midi_ins[a, 1] = 6 midi_ins[a, 2] = 1 a += 1
	midi_ins[a, 0] = "Telephone Ring" midi_ins[a, 3] = "Telephone"
	midi_ins[a, 1] = 7 midi_ins[a, 2] = 2 a += 1
	midi_ins[a, 0] = "Helicopter" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 2 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Applause" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 3 midi_ins[a, 2] = 0 a += 1
	midi_ins[a, 0] = "Gunshot" midi_ins[a, 3] = ""
	midi_ins[a, 1] = 3 midi_ins[a, 2] = 0 a += 1
	// Percussion

	// 0 = name
	// 1 = instrument
	// 2 = instrument pitch

	a = 0
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	// 12
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	// 24
	midi_drum[a, 0] = "[GS] Concert SD"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 12 a += 1
	midi_drum[a, 0] = "[GS] Snare Roll"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 5 a += 1
	midi_drum[a, 0] = "[GS] Finger Snap"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 18 a += 1
	midi_drum[a, 0] = "High Q"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 2 a += 1
	midi_drum[a, 0] = "Slap"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 9 a += 1
	midi_drum[a, 0] = "Scratch Push"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 6 a += 1
	midi_drum[a, 0] = "Scratch Pull"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 2 a += 1
	midi_drum[a, 0] = "Sticks"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 13 a += 1
	midi_drum[a, 0] = "Square Click"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 9 a += 1
	midi_drum[a, 0] = "Metronome Click"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 15 a += 1
	midi_drum[a, 0] = "Metronome Bell"
	midi_drum[a, 1] = 8 midi_drum[a, 2] = 18 a += 1
	midi_drum[a, 0] = "Acoustic Bass Drum"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 4 a += 1
	// 36
	midi_drum[a, 0] = "Electric Bass Drum"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 8 a += 1
	midi_drum[a, 0] = "Side Stick"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 8 a += 1
	midi_drum[a, 0] = "Acoustic Snare"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 15 a += 1
	midi_drum[a, 0] = "Hand Clap"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 19 a += 1
	midi_drum[a, 0] = "Electric Snare"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 16 a += 1
	midi_drum[a, 0] = "Low Floor Tom"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 6 a += 1
	midi_drum[a, 0] = "Closed Hi-hat"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 21 a += 1
	midi_drum[a, 0] = "High Floor Tom"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 9 a += 1
	midi_drum[a, 0] = "Pedal Hi-hat"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 23 a += 1
	midi_drum[a, 0] = "Low Tom"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 14 a += 1
	midi_drum[a, 0] = "Open Hi-hat"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 22 a += 1
	midi_drum[a, 0] = "Low-Mid Tom"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 17 a += 1
	// 48
	midi_drum[a, 0] = "High-Mid Tom"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 20 a += 1
	midi_drum[a, 0] = "Crash Cymbal 1"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 20 a += 1
	midi_drum[a, 0] = "High Tom"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 23 a += 1
	midi_drum[a, 0] = "Ride Cymbal 1"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 17 a += 1
	midi_drum[a, 0] = "Chinese Cymbal"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 14 a += 1
	midi_drum[a, 0] = "Ride Bell"
	midi_drum[a, 1] = 7 midi_drum[a, 2] = 17 a += 1
	midi_drum[a, 0] = "Tambourine"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 23 a += 1
	midi_drum[a, 0] = "Splash Cymbal"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 18 a += 1
	midi_drum[a, 0] = "Cowbell"
	midi_drum[a, 1] = 11 midi_drum[a, 2] = 6 a += 1
	midi_drum[a, 0] = "Crash Cymbal 2"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 21 a += 1
	midi_drum[a, 0] = "Vibraslap"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 17 a += 1
	midi_drum[a, 0] = "Ride Cymbal 2"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 24 a += 1
	// 60
	midi_drum[a, 0] = "High Bongo"
	midi_drum[a, 1] = 11 midi_drum[a, 2] = 16 a += 1
	midi_drum[a, 0] = "Low Bongo"
	midi_drum[a, 1] = 11 midi_drum[a, 2] = 9 a += 1
	midi_drum[a, 0] = "Mute Hi Conga"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = -3 a += 1
	midi_drum[a, 0] = "Open Hi Conga"
	midi_drum[a, 1] = 11 midi_drum[a, 2] = -1 a += 1
	midi_drum[a, 0] = "Low Conga"
	midi_drum[a, 1] = 11 midi_drum[a, 2] = -9 a += 1
	midi_drum[a, 0] = "High Timbale"
	midi_drum[a, 1] = 11 midi_drum[a, 2] = 5 a += 1
	midi_drum[a, 0] = "Low Timbale"
	midi_drum[a, 1] = 11 midi_drum[a, 2] = -4 a += 1
	midi_drum[a, 0] = "High Agogo"
	midi_drum[a, 1] = 9 midi_drum[a, 2] = 12 a += 1
	midi_drum[a, 0] = "Low Agogo"
	midi_drum[a, 1] = 9 midi_drum[a, 2] = 5 a += 1
	midi_drum[a, 0] = "Cabasa"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 35 a += 1
	midi_drum[a, 0] = "Maracas"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 32 a += 1
	midi_drum[a, 0] = "Short Whistle"
	midi_drum[a, 1] = 6 midi_drum[a, 2] = 34 a += 1
	// 72
	midi_drum[a, 0] = "Long Whistle"
	midi_drum[a, 1] = 6 midi_drum[a, 2] = 33 a += 1
	midi_drum[a, 0] = "Short Guiro"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 19 a += 1
	midi_drum[a, 0] = "Long Guiro"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 20 a += 1
	midi_drum[a, 0] = "Claves"
	midi_drum[a, 1] = 9 midi_drum[a, 2] = 19 a += 1
	midi_drum[a, 0] = "Hi Wood Block"
	midi_drum[a, 1] = 9 midi_drum[a, 2] = 7 a += 1
	midi_drum[a, 0] = "Low Wood Block"
	midi_drum[a, 1] = 9 midi_drum[a, 2] = 1 a += 1
	midi_drum[a, 0] = "Mute Cuica"
	midi_drum[a, 1] = 12 midi_drum[a, 2] = 22 a += 1
	midi_drum[a, 0] = "Open Cuica"
	midi_drum[a, 1] = 12 midi_drum[a, 2] = 13 a += 1
	midi_drum[a, 0] = "Mute Triangle"
	midi_drum[a, 1] = 7 midi_drum[a, 2] = 19 a += 1
	midi_drum[a, 0] = "Open Triangle"
	midi_drum[a, 1] = 8 midi_drum[a, 2] = 19 a += 1
	midi_drum[a, 0] = "Shaker"
	midi_drum[a, 1] = 4 midi_drum[a, 2] = 36 a += 1
	midi_drum[a, 0] = "Jingle Bell"
	midi_drum[a, 1] = 7 midi_drum[a, 2] = 21 a += 1
	// 84
	midi_drum[a, 0] = "Bell Tree"
	midi_drum[a, 1] = 8 midi_drum[a, 2] = 17 a += 1
	midi_drum[a, 0] = "Castanets"
	midi_drum[a, 1] = 9 midi_drum[a, 2] = 15 a += 1
	midi_drum[a, 0] = "Mute Surdo"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 12 a += 1
	midi_drum[a, 0] = "Open Surdo"
	midi_drum[a, 1] = 2 midi_drum[a, 2] = 7 a += 1
	midi_drum[a, 0] = "[GS] Applause"
	midi_drum[a, 1] = 3 midi_drum[a, 2] = 10 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	// 96
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	// 108
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	// 120
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1
	midi_drum[a, 0] = "----"
	midi_drum[a, 1] = -1 midi_drum[a, 2] = 0 a += 1

	midi_fadeout = []
	array_push(midi_fadeout, "Gunshot")
	array_push(midi_fadeout, "Applause")
	array_push(midi_fadeout, "Seashore")
	
	midi_fadein = []
	array_push(midi_fadein, "Reverse Cymbal")

}

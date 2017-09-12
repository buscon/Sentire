Synth(\skeys, [\atk, exprand(0.01,0.2), \ratio, Scale.whole.ratios.choose,  \amp, { rrand(0.3, 1.0); }.dup(4), \times, {rrand(0.5, 1.0)}.dup(4), \lpf_freq,  exprand(300, 2000), \fq, exprand(0.15, 0.5)]);

(

SynthDef(\skeys, { |freq_mul = 0.6, atk = 0.01, ratio = 1, amp = #[1,1,1,1], times = #[1,1,1,1], lpf_freq = 500, fq = 0.3|
	var sig, env;
	env = EnvGen.ar( Env.new([0, 1, 0], [atk, atk.linlin(0.01,0.4, 0.4, 1.0)], [4, -16]), doneAction:2);
	sig = Klank.ar(`[([200, 671, 1153, 1723] * ratio  * freq_mul), amp , times ], BrownNoise.ar([0.007, 0.007]) * env );
	sig = RLPF.ar(sig, lpf_freq * LFNoise2.kr(1).range(0.1, 2).poll, fq, 0.5);
	Out.ar(0, sig);
}).add;

SynthDef(\noisePlayer, { |out = 0, gate = 1, speed = 1, pos = 0, cutoff = 200, vol = 0.5, dur = 0.1, envelope_sel = 0, attack = 0.01, decay_time = 1, curve = -4, mulNoise = 0.1, bwr = 2, which_noise = 0, speedNoise = 10|
	var audio, rate,  env;

	env = 		Select.ar( envelope_sel,
			[
				EnvGen.ar(Env.perc(attack, decay_time *2, 1, curve:curve), gate, doneAction:2),
	EnvGen.ar(Env.sine(decay_time * 2, 1), gate, doneAction:2)

		]);

	audio = SelectX.ar(which_noise, [WhiteNoise.ar(mulNoise/4), PinkNoise.ar(mulNoise/4), BrownNoise.ar(mulNoise/8), Crackle.ar(2.0, mulNoise), Dust.ar(speedNoise, mulNoise*20), Impulse.ar(speedNoise,0,mulNoise*10) ]);
	audio = Resonz.ar(audio, cutoff, bwr);
	audio = LeakDC.ar(audio)!2;

  Out.ar(out, audio * env * vol *4);
}).add;

SynthDef(\wavPlayer, { |out = 0, bufnum = 0, gate = 1, speed = 1, pos = 0, cutoff = 200, vol = 0.5, dur = 0.1, envelope_sel = 0, attack = 0.01, decay_time = 1, curve = -4|
	var audio, rate,  env;
	// randomize position
	//pos = TRand.kr(0,1,gate)
	pos = pos*BufFrames.kr(bufnum);
	// use PulseCount because PlayBuf starts right away whatever trigger is
	rate = BufRateScale.kr(bufnum)*speed*(PulseCount.kr(gate) >= 1);
  // env
	env = 		Select.ar( envelope_sel,
			[
				EnvGen.ar(Env.perc(attack, decay_time *2, 1, curve:curve), gate, doneAction:2),
	EnvGen.ar(Env.sine(decay_time * 2, 1), gate, doneAction:2)
			//,	EnvGen.ar(Env.sine(decay_time * 2, 10), gate, doneAction:2)

		]);

//	env = EnvGen.ar(Select.kr(which, [Env.sine(dur,2),Env.perc(attack], gate, doneAction:2);
  audio = PlayBuf.ar(1, bufnum, rate, gate, pos, doneAction:2);
  audio = BLowPass.ar(in: audio, freq: cutoff);
	audio = LeakDC.ar(audio)!2;
 // SendTrig.kr(gate,0,bufnum);
  Out.ar(out, audio * env * vol);
}).add;


SynthDef(\granulator, { arg out = 0, volume = 0, bufNum = 0, pos = 0, trigRate = 1, trigRateR = 0,  rate = 1, frate = 1, freqLPF = 22000, amtRnd = 0, lfoR = 20, dur = 0.15, overlap = 1,
	amFreq = 64, amVol = 0,
	gate = 1.0, freqMIDI = 64,
	ffreq_low = 22000, drywet = -0.8,
	panMax = 1, amp = 1, interp = 4,  rndTrigRate = 0, speedRndTrigRate = 5, speedRndRate = 5, rndRate = 0, pan = 0, mulPan = 0;

    var trate, rndPos, ausgang, am, midiOsc, freqMod, sig, reverbered, chain, r_list;
	r_list = [ 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/10, 1/12, 1/14, 1/16, 1/20, 1/24, 1/28, 1/32, 1/40, 1/48, 1/56, 1/64];
	rate = rate * frate;
	rndPos = LFNoise0.kr(lfoR, amtRnd);
	trigRateR = (trigRateR + LFNoise0.kr(speedRndTrigRate, rndTrigRate)).abs ;
	trate = (trigRate + Select.kr(trigRateR, r_list.reciprocal) + Select.kr(LFNoise0.kr(speedRndTrigRate, rndTrigRate), r_list.reciprocal)).abs;
	//trate = (trigRate + LFNoise0.kr(speedRndTrigRate, rndTrigRate)).abs ;
	rate = rate + LFNoise0.kr(speedRndRate, rndRate);
	ausgang = TGrains2.ar(2, Impulse.kr(trate.poll) , bufNum, rate, ((pos + rndPos).range(0,  BufDur.kr(bufNum))) , dur , 0, amp, 0.01);

	// AM
	am = SinOsc.ar( freqMIDI+amFreq, mul:amVol*1.5) * SinOsc.ar( (freqMIDI+amFreq)/2, mul:amVol*1.5);

	//ausgang = RLPF.ar(ausgang, ffreq_low, 0.9);
	ausgang = XFade2.ar(ausgang, ausgang * am, amVol.linlin(0, 1, -1, 1));
	ausgang = LPF.ar(ausgang, freqLPF.lag(1));

	//ausgang = EnvGen.kr(Env.adsr(attackTime: 0.01, sustainLevel: 1, decayTime: 0.5, releaseTime:1),gate, Latch.kr(gate,gate)) * ausgang;
	//ausgang = Array.fill(8, CombN.ar(ausgang, 0.2, {rrand(0.05, 0.01)}, {rrand(0.3, 0.01)} , 1/8));
	sig = Mix.new(ausgang).softclip(0.9);

	//chain = Mix.new( chain );
	//reverbered = GVerb.ar(ausgang, 10, 3 );

	//sig = XFade2.ar(ausgang, reverbered, drywet);
	sig = Pan2.ar(sig, pan + LFNoise0.kr(1, mulPan));
	sig = LeakDC.ar(sig);
	Out.ar(out, sig * volume  );

}).add;

~granbuf = Ndef(\grainbuf, {arg trigRate = 1, dur = 0.1, bufnum = 0, rate = 1, pos = 0, envbuf = -1, volume = 0, amtRnd = 0, lfoR = 20, speedRndTrigRate = 5, rndTrigRate = 0;
        var grains, trig, buffers, curbuf, rndPos, trate;
	trate = (trigRate + LFNoise0.kr(speedRndTrigRate, rndTrigRate)).abs ;
        trig = Impulse.ar(trate);
	rndPos = LFNoise0.kr(lfoR, amtRnd);

        grains = GrainBuf.ar(2, trig, dur, bufnum, rate, ((pos + rndPos).range(0,  BufDur.kr(bufnum))), 4, 0, envbuf);
        Out.ar(0, grains * volume)
        }).play;

Ndef(\pad, { arg  freqMul = 0.6,  master_vol = 0.5, volume = 0, mulNoiseFreq = 0.5;
	var sig;
	var scale = Scale.choose;
	var freq = { [ 261.6255653006, 321.50005749269, 644.02146481203, 834.95751705018].choose  * LFNoise2.kr(1,0.01 * Lag3UD.kr(mulNoiseFreq, 2, 0),1) }!48;
        var gen =  LFPulse.ar(freq* freqMul) * 0.1;
        var fmod = LFCub.kr(1/12).range(1, 2); // modulate filter with mouse
        var rqmod = LFNoise2.kr(1/8).range(0.1,1.0);

	sig = RLPF.ar(gen, (freq * fmod) , rqmod) * master_vol * Lag3UD.kr(volume, 0, 0.5);
	sig = Mix.ar(sig)!2 * 0.1;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	Out.ar(0, sig);
}).play;

Ndef(\drone, {| vol = 0, freq_mul = 0.7, lpf_freq = 500, dev =0 |
	var num = 50, ratios, sig;
	num = 50;//MouseY.kr(1,50);//50;
	ratios = Scale.rast.ratios;

	sig = RLPF.ar(Ringz.ar(PinkNoise.ar(0.1),

		[ [ 3332, 3332 ], [ 2055, 2055 ], [ 1255, 1255 ], [ 3535, 3535 ], [ 1302, 1302 ], [ 845, 845 ], [ 834, 834 ], [ 3819, 3819 ], [ 2144, 2144 ], [ 2916, 2916 ], [ 2917, 2917 ], [ 1492, 1492 ], [ 1527, 1527 ], [ 2353, 2353 ], [ 1445, 1445 ], [ 1304, 1304 ], [ 2532, 2532 ], [ 2170, 2170 ], [ 1907, 1907 ], [ 3156, 3156 ], [ 1091, 1091 ], [ 3657, 3657 ], [ 3996, 3996 ], [ 3035, 3035 ], [ 3300, 3300 ], [ 3394, 3394 ], [ 1646, 1646 ], [ 3263, 3263 ], [ 1976, 1976 ], [ 1049, 1049 ], [ 3534, 3534 ], [ 2587, 2587 ], [ 3495, 3495 ], [ 1232, 1232 ], [ 1383, 1383 ], [ 967, 967 ], [ 2541, 2541 ], [ 2326, 2326 ], [ 3105, 3105 ], [ 3644, 3644 ], [ 1130, 1130 ], [ 3736, 3736 ], [ 2858, 2858 ], [ 2892, 2892 ], [ 1429, 1429 ], [ 3956, 3956 ], [ 1239, 1239 ], [ 1813, 1813 ], [ 1641, 1641 ], [ 3055, 3055 ] ]


		//[ [ 2706, 2706 ], [ 2470, 2470 ], [ 2541, 2541 ], [ 1233, 1233 ], [ 2208, 2208 ], [ 2371, 2371 ], [ 998, 998 ], [ 3325, 3325 ], [ 1293, 1293 ], [ 1992, 1992 ], [ 1083, 1083 ], [ 1732, 1732 ], [ 1579, 1579 ], [ 3990, 3990 ], [ 2564, 2564 ], [ 3849, 3849 ], [ 795, 795 ], [ 2127, 2127 ], [ 1820, 1820 ], [ 321, 321 ], [ 2914, 2914 ], [ 3664, 3664 ], [ 2965, 2965 ], [ 1428, 1428 ], [ 1569, 1569 ], [ 949, 949 ], [ 504, 504 ], [ 3819, 3819 ], [ 1116, 1116 ], [ 1961, 1961 ], [ 3628, 3628 ], [ 2179, 2179 ], [ 3075, 3075 ], [ 836, 836 ], [ 1583, 1583 ], [ 2074, 2074 ], [ 3172, 3172 ], [ 623, 623 ], [ 2393, 2393 ], [ 3823, 3823 ], [ 2246, 2246 ], [ 2232, 2232 ], [ 1868, 1868 ], [ 1099, 1099 ], [ 2224, 2224 ], [ 1420, 1420 ], [ 1404, 1404 ], [ 2013, 2013 ], [ 454, 454 ], [ 2923, 2923 ] ]

		* freq_mul * 1.gauss(dev) , {rrand(0.1, 1)}.dup(num), 1).mean, lpf_freq)  * 1;

	Out.ar(0, sig * vol);


}).play;
)
m.gui


(
~wavPath= "/Users/marcello/Music/Samples/Touch/selection/*.wav";
~wavFiles = ~wavPath.pathMatch;
~buffers = ~wavFiles.collect( {|buf| Buffer.readChannel(s, buf, channels:[0])} );

~martin= Buffer.readChannel(s,"/Users/marcello/Music/Samples/MartinLau/martin_nosilence.wav", channels:[0]);
~rieko1 = Buffer.readChannel(s,"/Users/marcello/Music/Samples/Piano/Inside/stone.wav", channels:[0]);
~rieko2 = Buffer.readChannel(s,"/Users/marcello/Music/Samples/Piano/Inside/slow_keys.wav", channels:[0]);
~noise = Buffer.readChannel(s,"/Users/marcello/Music/Samples/musicradar-noise-hiss-crackle-samples/White_Noise_Raw/Modular_Raw_d.wav", channels:[0]);


~clara1 = Buffer.readChannel(s, "/Users/marcello/Music/Samples/Touch/selection/touch sound_edit.wav", channels:[0]);

~clara2 = Buffer.readChannel(s, "/Users/marcello/Music/Samples/Touch/selection/touch kurz_edit.wav", channels:[0]);

~merleau1 = Buffer.readChannel(s, "/Users/marcello/Music/Samples/Touch/MerleauPonty.aiff", channels:[0]);
~rieko3 = Buffer.readChannel(s,"/Users/marcello/Music/Samples/Piano/Inside/bell_plucking.wav", channels:[0]);

~gran = Synth(\granulator, [\volume, 0, \bufnum, ~clara1]);

)
~rieko1 = Buffer.readChannel(s,"/Users/marcello/Music/Samples/Piano/Inside/stone.wav", channels:[0]);
~rieko2 = Buffer.readChannel(s,"/Users/marcello/Music/Samples/Piano/Inside/bell_plucking.wav", channels:[0]);

~rieko3 = Buffer.readChannel(s,"/Users/marcello/Music/Samples/Piano/Inside/slow_keys_normalized.wav", channels:[0]);
~noise
(
w = Env([0, 1, 0], [1, 0.1], [8, -16]);
w = Env.perc(0.01, 2);
z = Buffer.sendCollection(s, w.discretize, 1);
~granbuf.set(\volume, 1, \bufnum, ~merleau1, \amtRnd, 0.0005, \trigRate, 2, \pos,
	rrand(0.00, 0.99).postln,
	//0.97915740609169,
	\dur, 0.5, \envbuf, -1);
//list of pos: [0.97915740609169,
)
~granbuf.set(\volume, 1);
~granbuf.set(\pos, 0.2);
~granbuf.set(\trigRate, 10);
~granbuf.set(\dur, 0.1);

Synth(\wavPlayer,  [ \bufnum, ~noise, \speed , 1, \pos, rrand(0.0, 0.9).postln, \dur , 0.5, \envelope_sel , 1, \attack , 0.01, \cutoff, rrand(50, 200).postln, \decay_time , 0.5, \curve, -4, \vol, 0.25]);

Synth(\wavPlayer,  [ \bufnum, ~martin, \speed , 1, \pos, rrand(0.0, 0.9).postln, \dur , 0.2, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000).postln, \decay_time , 0.2, \curve, -4, \vol, 0.5]);

	~granbuf.free

~gran = Synth(\granulator, [\volume, 1, \bufnum, ~merleau1]);
~gran.set(\bufnum, ~rieko1);
~gran.set(\volume, 0.5);
~rieko1.plot
~gran.set(\pos, 0.1);
~gran.set(\trigRate, 10);
~gran.set(\rndTrigRate, 5);
~gran.set(\dur, 0.2);
~gran.set(\envbuf, z);
~gran.set(\envbuf, -1);

~gran.set(\amtRnd, 0.1);
)
~gran.free
Synth(\noisePlayer, [\cutoff, exprand(80, 300).postln, \vol , 0.5, \dur , 0.1, \envelope_sel , 1, \attack , 0.01, \decay_time , 0.1, \curve , -16, \mulNoise , 0.5, \bwr , rrand(0.6,2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30).postln]);

Synth(\noisePlayer, [\cutoff, exprand(5000, 10000).postln, \vol , 0.5, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30).postln]);

Synth(\noisePlayer, [\cutoff, exprand(200, 1000).postln, \vol , 0.8, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 1, \bwr , 0.05, \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30).postln]);

(
Synth(\noisePlayer, [\cutoff, exprand(200, 1000).postln, \vol , 0.5, \dur , 0.2, \envelope_sel , 0, \attack , 0.01, \decay_time , 0.2, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.1,0.4), \which_noise ,
	//[0,1,2,3,4,5].wchoose([0.2,0.2,0.2,0.1,0.1,0.1])
	rrand(3, 5).postln

	, \speedNoise, rrand(20, 30).postln]);
)
		Ndef(\pad).set(\master_volume, 0);

		Ndef(\pad).set(\volume, 1);Ndef(\pad).set(\mulNoiseFreq, 1);
		Ndef(\pad).set(\volume, 0);Ndef(\pad).set(\mulNoiseFreq, 1);

Ndef(\pad).set(\mulNoiseFreq, 80);
Ndef(\pad).set(\mulNoiseFreq, 1);

Ndef(\drone).set(\vol, 0.5);

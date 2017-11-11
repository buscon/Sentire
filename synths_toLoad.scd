//Synth(\skeys, [\atk, exprand(0.01,0.2), \ratio, Scale.whole.ratios.choose,  \amp, { rrand(0.3, 1.0); }.dup(4), \times, {rrand(0.5, 1.0)}.dup(4), \lpf_freq,  exprand(300, 2000), \fq, exprand(0.15, 0.5)]);

(


SynthDef(\glitch_sounds, { arg outbus = 0, modN = 0.5, modF = 0, modAmp1 = 0, modAmp2 = 1, modAmp3 = 1, modC = 1, gpos = 0,  master_volume = 0;
	var chain, snd;

	snd = BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3 *  Rand(0,400) * modN  )!2
	+
	BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3  * Rand(0,400)* modN )!2
	+
	BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3  * Rand(0,400) * modN )!2 ;
	snd = BrownNoise.ar(modF, snd) + snd;
	snd = snd.clip2(0.5);
	snd = Array.fill(8, CombN.ar(snd, 0.2, {rrand(0.05,0.1)} * modC, {rrand(0.1,1)} * modC, 1/8));
	snd = Mix.new(snd);

	//snd = GVerb.ar(snd, 5, 0.83423432, 0.5, spread:15, mul:0.2);
	snd = Pan2.ar(snd, gpos);
	snd = LeakDC.ar(snd) * 0.05;
	Out.ar(outbus, snd * master_volume).clip2(0.5);

}).add;

SynthDef(\glitch_sounds_perc, { arg outbus = 0, modN = 0.5, modF = 0, modAmp1 = 0, modAmp2 = 1, modAmp3 = 1, modC = 1, gpos = 0,  master_volume = 0;
	var chain, snd;

	snd = BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3 *  Rand(0,400) * modN  )!2
	+
	BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3  * Rand(0,400)* modN )!2
	+
	BPF.ar(WhiteNoise.ar(mul: SinOsc.ar(modF,phase:Rand (0,pi), mul:Rand( 0.1,1) )),modAmp1 * modAmp2 * modAmp3  * Rand(0,400) * modN )!2 ;
	snd = snd * EnvGen.ar(Env.perc(0.01, 0.25), doneAction:2);
	snd = BrownNoise.ar(modF, snd) + snd;
	snd = snd.clip2(0.5);
	snd = Array.fill(8, CombN.ar(snd, 0.2, {rrand(0.05,0.1)} * modC, {rrand(0.1,1)} * modC, 1/8));
	snd = Mix.new(snd);

	//snd = GVerb.ar(snd, 5, 0.83423432, 0.5, spread:15, mul:0.2);
	snd = Pan2.ar(snd, gpos);
	snd = LeakDC.ar(snd) * 0.05;
	Out.ar(outbus, snd * master_volume).clip2(0.5);

}).add;

SynthDef(\skeys, { |freq_mul = 0.6, atk = 0.01, ratio = 1, amp = #[1,1,1,1], times = #[1,1,1,1], lpf_freq = 500, fq = 0.3|
	var sig, env;
	env = EnvGen.ar( Env.new([0, 1, 0], [atk, atk.linlin(0.01,0.4, 0.4, 1.0)], [4, -16]), doneAction:2);
	sig = Klank.ar(`[([200, 671, 1153, 1723] * ratio  * freq_mul), amp , times ], BrownNoise.ar([0.007, 0.007]) * env );
	sig = RLPF.ar(sig, lpf_freq * LFNoise2.kr(1).range(0.1, 2), fq, 0.5);
	Out.ar(0, sig);
}).add;

SynthDef(\noisePlayer, { |out = 0, gate = 1, speed = 1, pos = 0, cutoff = 200, vol = 0.5, dur = 0.1, envelope_sel = 0, attack = 0.01, decay_time = 1, curve = -4, mulNoise = 0.1, bwr = 2, which_noise = 0, speedNoise = 10, gpos = 0|
	var audio, rate,  env;

	env = 		Select.ar( envelope_sel,
		[
			EnvGen.ar(Env.perc(attack, decay_time *2, 1, curve:curve), gate, doneAction:2),
			EnvGen.ar(Env.sine(decay_time * 2, 1), gate, doneAction:2)

	]);

	audio = SelectX.ar(which_noise, [WhiteNoise.ar(mulNoise/4), PinkNoise.ar(mulNoise/4), BrownNoise.ar(mulNoise/8), Crackle.ar(2.0, mulNoise), Dust.ar(speedNoise, mulNoise*20), Impulse.ar(speedNoise,0,mulNoise*10) ]);
	audio = Resonz.ar(audio, cutoff, bwr);
	audio = LeakDC.ar(audio);
	audio = Pan2.ar(audio, gpos);


	Out.ar(out, audio * env * vol *4);
}).add;

SynthDef(\noisePlayerContinuous, { |out = 0, gate = 1, speed = 1, pos = 0, cutoff = 200, vol = 0.5, dur = 0.1, envelope_sel = 0, attack = 0.01, decay_time = 1, curve = -4, mulNoise = 0.1, bwr = 2, which_noise = 0, speedNoise = 10|
	var audio, rate,  env;



	audio = SelectX.ar(which_noise, [WhiteNoise.ar(mulNoise/4), PinkNoise.ar(mulNoise/4), BrownNoise.ar(mulNoise/8), Crackle.ar(2.0, mulNoise), Dust.ar(speedNoise, mulNoise*20), Impulse.ar(speedNoise,0,mulNoise*10) ]);
	audio = Resonz.ar(audio, cutoff, bwr);
	audio = LeakDC.ar(audio);
	audio = Pan2.ar(audio, LFNoise0.kr(1).range(-0.5, 0.5));

	Out.ar(out, audio * vol *4);
}).add;

SynthDef(\wavPlayer, { |out = 0, bufnum = 0, gate = 1, speed = 1, pos = 0, cutoff = 200, vol = 0.5, dur = 0.1, envelope_sel = 0, attack = 0.01, decay_time = 1, curve = -4, gpos= 0|
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
	audio = LeakDC.ar(audio);


	audio = Pan2.ar(audio, gpos);

	// SendTrig.kr(gate,0,bufnum);
	Out.ar(out, audio * env * vol);
}).add;

/*
SynthDef(\granulator, { arg out = 0, volume = 0, bufnum = 0, pos = 0, trigRate = 1, trigRateR = 0,  rate = 1, frate = 1, freqLPF = 22000, amtRnd = 0, lfoR = 20, dur = 0.15, overlap = 1,
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
ausgang = TGrains2.ar(2, Impulse.kr(trate) , bufnum, rate, ((pos + rndPos).range(0,  BufDur.kr(bufnum))) , dur , 0, amp, 0.01);

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


Ndef(\sinus, {|freq = 200|
var sig;
sig = SinOsc.ar(freq, 0, 0.4)!2;
Out.ar(0, sig);

}).play;

~granbuf = Ndef(\grainbuf, {arg trigRate = 1, dur = 0.1, bufnum = 0, rate = 1, pos = 0, envbuf = -1, volume = 0, amtRnd = 0, lfoR = 20, speedRndTrigRate = 5, rndTrigRate = 0;
var grains, trig, buffers, curbuf, rndPos, trate;
trate = (trigRate + LFNoise0.kr(speedRndTrigRate, rndTrigRate)).abs ;
trig = Impulse.ar(trate);
rndPos = LFNoise0.kr(lfoR, amtRnd);

grains = GrainBuf.ar(2, trig, dur, bufnum, rate, ((pos + rndPos).range(0,  BufDur.kr(bufnum))), 4, 0, envbuf);
Out.ar(0, grains * volume)
}).play;

*/
SynthDef(\timpano,
	{arg ress = 0, choose = 0, volume = 1, atk = 0;
		var klank, env;
		klank = Klank.ar(`[choose !12, {Rand(0.128,0.700)}!12],BrownNoise.ar(0.3));
		klank = klank;
		env = EnvGen.kr(Env.perc(atk, ress), doneAction:2);
		Out.ar(0, klank*env.dup*0.00128*volume);
}).add;

SynthDef(\crazy_pad_perc, { arg  freqMul = 0.6, freqMul2 = 1, master_vol = 0.5, volume = 0, mulNoiseFreq = 0.5, mulNoiseFreq2 = 0.1, releaseEnv = 1;
	var sig, env;
	var scale = Scale.choose;
	var freq = { [ 261.6255653006, 321.50005749269, 644.02146481203, 834.95751705018].choose  * freqMul2 * LFNoise2.kr(1,0.01 * Lag3UD.kr(mulNoiseFreq + mulNoiseFreq2, 0, 0),1) }!24;
	var gen =  LFSaw.ar(freq* freqMul) * 0.3;
	var fmod = 1;//LFCub.kr(1/12).range(1, 2); // modulate filter with mouse
	var rqmod = LFNoise2.kr(1/8).range(0.1,1.0);

	sig = gen;
	env = EnvGen.ar( Env.perc(0.01, releaseEnv), doneAction:2);

	sig = RLPF.ar(sig, (freq * fmod* freqMul *3)  , rqmod) * master_vol * Lag3UD.kr(volume, 0, 0.5);
	sig = Mix.ar(sig)!2 * 0.25 * env;

	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	Out.ar(0, sig);
}).add;

SynthDef(\wedSynth,{arg 	midinote=60,
	octave=0,
	dronelvl=0.5,
	mDist = 1,
	rMix = 0.25,
	rRoom = 0.15,
	pitchBend = 0.01,
	mod = 0.3,
	volume = 0,
	mButton,
	daBuff;


	var vals, buf,  s, drone, noise, melody, pulse, root;
	root = midinote+(12*octave);
	f = root.midicps;							//Root frequency
	g = (root+19).midicps;						//Compound fifth above root frequency
	//pitchBend = MouseX.kr(0, 1);
	x = pitchBend.linexp(0.001, 1.0, f, g).lag(1);
	y = mod.linexp(0.001, 1.0, 0.25, 0.05);
	z = Index.kr(daBuff, 10);
	mButton = [[x, x*2], [z, z*2] ];

	/////////Synths//////////////
	drone = SinOsc.ar([f, f/2], mul:1)*									EnvGen.kr(Env.new(
		Array.rand(16, 0, 0.2),  //Random drones
		Array.rand(15, 1, 5),
		'exponential',
		0,
		1));

	noise = Ringz.ar(WhiteNoise.ar(0.005),
		f*2,
		mul:MouseY.kr(0.15,0.25,'exponential')
	);

	melody = Mix.ar([SinOsc.ar(KeyState.kr(
		46,		//m key
		mButton,
		0),
	SinOsc.kr(y*50, 0, 1),  	//Phase modulation controlled by mouse
	mDist).wrap2(1)*y]);		//Amplitude controlled by mouse

	pulse = LFPulse.ar(KeyState.kr(
		46,
		mButton,
		0.8),
	0,
	LFTri.kr(0.2, 0, 0.5, 0.5),
	y/4);

	/////////Output//////////////
	Out.ar(0,
		Mix.ar([
			drone*dronelvl,
			FreeVerb.ar(drone*dronelvl,
				0.8,
				0.7),
			FreeVerb.ar(Mix.new([
				melody,
				Latch.ar(pulse, noise)
			]),
			rMix,
			rRoom
			),
			noise
		]) * volume
	);
}).add;

SynthDef(\risset, {|out = 0, pan = 0, freq = 400, amp = 0.1, dur = 2, gate = 1|
	var amps = #[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
	var durs = #[1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
	var frqs = #[0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
	var dets = #[0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
	var doneActionEnv = EnvGen.ar(Env.linen(0, dur, 0), gate, doneAction: 2);
	var src = Mix.fill(11, {|i|
		var env = EnvGen.ar(Env.perc(0.005, dur*durs[i], amps[i], -4.5), gate);
		SinOsc.ar(freq*frqs[i] + dets[i], 0, amp*env);
	});
	src = src * doneActionEnv * 0.5; // make sure it releases node after the end.
	Out.ar(out, Pan2.ar(src, pan));
}).add;

SynthDef(\sinTrig, { arg  freq = 58, volume = 0.5;
	var sig;


	sig = SinOsc.ar(  freq, 0,

		EnvGen.ar(Env.perc, doneAction:2) * 0.25

	);
	sig = Splay.ar(sig);
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 40);
	Out.ar(0, sig * volume);

}).add;

SynthDef(\pulse_perc,{ arg freq = 180,delayTime = 0.03,amp = 1.0,attack = 0.01;
	var out,out2,env;
	// with touch, trigger a sequence of frequencies
	freq = freq;
	delayTime = delayTime * LFNoise2.kr(1).range(0.9, 1.1);

	z = SinOsc.ar(freq * SinOsc.kr(1).range(0.9, 1.1),0,0.7);
	env = EnvGen.ar(Env.perc, doneAction:2);
	out = z * env;
	out = Pan2.ar(out, SinOsc.kr(5,1.0pi), 0.1 );

	out = out.clip2(1);
	//	out = FreeVerb.ar(out,0.7,1.0,0.4, amp);
	//	DetectSilence.ar(out, doneAction:2);
	Out.ar(0, out);
}).add;

SynthDef(\mod_bubble, { arg proximity = 0, freq = 500, freq_mod =20, volume = 0.5;
	var in, sig;
	//	proximity = MouseX.kr(0.0, 1.0);
	freq = freq + freq_mod;
	in = Blip.ar(
		//		SinOsc.kr(5,0,20,10).poll,
		freq_mod,
		100, 0.1);
	sig =  Formlet.ar(in, freq, 0.005, 0.04) * EnvGen.ar(Env.perc(), doneAction:2);
	sig = LPF.ar(sig, freq*2, 1);
	sig = sig + CombC.ar(sig, 1, rrand( 0.5, 0.3), rrand( 5, 2), 1);
	sig = Pan2.ar(sig, SinOsc.kr(LFNoise0.kr(1).range(1.0, 5.0),1.0pi), 1);

	sig = sig * volume;
	Out.ar(0, sig);
}).add;

SynthDef(\twinP, {arg root_freq = 1, scale_freq = 0.4, touched = 1, proximity = 1, volume = 1;
	var density, env, env2, decay,snd;
	//var proximity = MouseX.kr(0,1);
	var freq = { [60,64,65,67].choose.midicps * LFNoise2.kr(1, 0.01 * touched, 1) }!48 * proximity.linlin(0, 1, 0.99, 1.01).round(0.001) * root_freq * scale_freq ;
	//       var freq = { [60,64,65,67].choose.midicps }!24;
	var gen = LFSaw.ar(
		freq +
		SinOsc.ar(proximity.linlin(0, 1, 1, 10),
			1,//mul: MouseX.kr(0,20)
		)
	) * 0.1;
	var fmod = LFNoise2.kr(1, add:1).range(proximity.linlin(0, 1, 0, 10), proximity.linlin(0, 1, 1, 20)); // modulate filter with mouse
	var rqmod = LFNoise2.kr(1/8).range(0.1,1.0);
	env = EnvGen.ar(Env.linen(0.1,0.5,2,1,-4), doneAction: 2);
	snd = RLPF.ar(gen, freq * fmod * 0.125, rqmod, 1) * env;
	//	snd = Array.fill(6, CombN.ar(snd, 0.2, {rrand(0.01,0.1)}, 1));
	snd = Splay.ar(snd) * volume ;
	Out.ar(0, snd)

}).add;


SynthDef(\blowing, { arg root = 36, touched = 1, proximity = 1, volume = 1;
	//	var proximity = MouseX.kr(0,1).round(0.001);
	var env;
	var dur = 8;
	var num = 8;
	var freq = root.midicps;
	var spread = rrand(0.4,0.8);
	var attack = rrand(0.05, 0.3);


	// play the cluster

	var harm = Array.geom(num, 1, 1.5);
	var harma = Array.geom(num, 0.5, 0.8);
	var detune = Array.fill(num, { LFNoise2.kr(1,0.01 * touched,1) }) * proximity.linlin(0.2, 1, 0.95, 1.05);
	var source = PinkNoise.ar * SinOsc.ar(freq * detune * 2);
	var bandwidth = 0.0001 * proximity.linexp(0.3, 1, 200, 0.1);
	var generator =
	SinOsc.ar(freq*harm*detune , mul:harma*0.005) +
	Resonz.ar(source, freq*harm*detune, bandwidth, mul:harma) *
	50
	//	(bandwidth.reciprocal.poll)
	;

	var snd;
	//snd = (generatorUp * aEnvUp) + (generatorDown * aEnvDown * 0.5) + (generator * 0.1);
	snd = RLPF.ar(generator, (freq*detune*proximity.linlin(0.2, 1, 1.0, 3.0) ), proximity.linlin(0.2, 1, 1.0, 0.25), 2);
	env = EnvGen.ar(Env.linen(0.1,0.5,2,1,-4), doneAction: 2);
	snd = Splay.ar(snd, spread);
	snd = Splay.ar(snd, spread) *0.25;
	snd = LeakDC.ar(snd) * volume * env;
	snd = Limiter.ar(snd, 0.9);
	Out.ar(0, snd);
}).add;

)







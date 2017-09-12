(

SynthDef(\noisePlayer, { |out = 0, gate = 1, speed = 1, pos = 0, cutoff = 200, vol = 0.5, dur = 0.1, envelope_sel = 0, attack = 0.01, decay_time = 1, curve = -4, mulNoise = 0.1, bwr = 2, which_noise = 0, speedNoise = 10|
	var audio, rate,  env;
	// randomize position
	//pos = TRand.kr(0,1,gate)
	// use PulseCount because PlayBuf starts right away whatever trigger is
  // env
	env = 		Select.ar( envelope_sel,
			[
				EnvGen.ar(Env.perc(attack, decay_time *2, 1, curve:curve), gate, doneAction:2),
	EnvGen.ar(Env.sine(decay_time * 2, 1), gate, doneAction:2)
			//,	EnvGen.ar(Env.sine(decay_time * 2, 10), gate, doneAction:2)

		]);

//	env = EnvGen.ar(Select.kr(which, [Env.sine(dur,2),Env.perc(attack], gate, doneAction:2);
	audio = SelectX.ar(which_noise, [WhiteNoise.ar(mulNoise/4), PinkNoise.ar(mulNoise), BrownNoise.ar(mulNoise), Crackle.ar(2.0, mulNoise), Dust.ar(speedNoise, mulNoise*6), Impulse.ar(speedNoise,0,mulNoise*6) ]);
	audio = Resonz.ar(audio, cutoff, bwr);
	audio = LeakDC.ar(audio)!2;
 // SendTrig.kr(gate,0,bufnum);
  Out.ar(out, audio * env * vol);
}).add;

)

Synth(\noisePlayer, [\cutoff, exprand(40, 10000).postln, \vol , 1, \dur , 0.1, \envelope_sel , rrand(0, 1), \attack , exprand(0.01, 0.3), \decay_time , rrand(0.01, 1.0), \curve , -4, \mulNoise , 0.3, \bwr , rrand(0.1, 2.0).postln, \which_noise , rrand(0, 5).postln, \speedNoise, rrand(1, 100).postln]);
Synth(\noisePlayer, [\cutoff, exprand(40, 10000).postln, \vol , 1, \dur , 0.1, \envelope_sel , rrand(0, 1), \attack , exprand(0.01, 0.3), \decay_time , rrand(0.01, 1.0), \curve , -4, \mulNoise , 0.3, \bwr , rrand(0.1, 2.0).postln, \which_noise , 5, \speedNoise, rrand(1, 100).postln]);


{ Resonz.ar(WhiteNoise.ar(0.5), MouseX.kr(40,10000,1).poll, 0.1)!2 }.play
(

// activate left and right channels

Synth("noiseToPitch", [\out, 0, \mul, 1]);

Synth("noiseToPitch", [\out, 1, \mul, 1]);

)
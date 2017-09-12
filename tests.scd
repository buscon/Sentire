(
Ndef(\gaussS, {|dev = 0|
	var sig, freq = 300;
	dev = MouseX.kr(0.0001, 5000, 1).rand(1).poll;
	sig = SinOsc.ar(freq.gauss(dev), 0, 0.25);
	Out.ar(0, sig);
}).play;

)
GrainSin
(
Ndef(\drone, {| vol = 0.5, freq_mul = 0.7, lpf_freq = 500, dev =50 |
	var num = 50, ratios, sig;
	num = 50;//MouseY.kr(1,50);//50;
	ratios = Scale.rast.ratios;
	dev = MouseX.kr(0.0, 1.0).poll;
	sig = RLPF.ar(Ringz.ar(PinkNoise.ar(0.1),

		[ [ 3332, 3332 ], [ 2055, 2055 ], [ 1255, 1255 ], [ 3535, 3535 ], [ 1302, 1302 ], [ 845, 845 ], [ 834, 834 ], [ 3819, 3819 ], [ 2144, 2144 ], [ 2916, 2916 ], [ 2917, 2917 ], [ 1492, 1492 ], [ 1527, 1527 ], [ 2353, 2353 ], [ 1445, 1445 ], [ 1304, 1304 ], [ 2532, 2532 ], [ 2170, 2170 ], [ 1907, 1907 ], [ 3156, 3156 ], [ 1091, 1091 ], [ 3657, 3657 ], [ 3996, 3996 ], [ 3035, 3035 ], [ 3300, 3300 ], [ 3394, 3394 ], [ 1646, 1646 ], [ 3263, 3263 ], [ 1976, 1976 ], [ 1049, 1049 ], [ 3534, 3534 ], [ 2587, 2587 ], [ 3495, 3495 ], [ 1232, 1232 ], [ 1383, 1383 ], [ 967, 967 ], [ 2541, 2541 ], [ 2326, 2326 ], [ 3105, 3105 ], [ 3644, 3644 ], [ 1130, 1130 ], [ 3736, 3736 ], [ 2858, 2858 ], [ 2892, 2892 ], [ 1429, 1429 ], [ 3956, 3956 ], [ 1239, 1239 ], [ 1813, 1813 ], [ 1641, 1641 ], [ 3055, 3055 ] ]

		* freq_mul  * 1.gauss(dev), {rrand(0.1, 1)}.dup(num), 1).mean, lpf_freq)  * 1;

	Out.ar(0, sig * vol);


}).play;
)
1.gauss(0.1)

(

SynthDef(\help_Klank, { arg out=0, i_freq;
    var klank, n, harm, amp, ring, env, atk = 0.01, sus = 0.1, rel = 0.1;

    // harmonics
    harm = \harm.ir(Array.series(4, 1, 1).postln);
    // amplitudes
    amp = \amp.ir(Array.fill(4, 0.05));
    // ring times
    ring = \ring.ir(Array.fill(4, 1));

    env = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction:2);
	//env = Env.perc();
	klank = Klank.ar(`[harm, amp, ring], {ClipNoise.ar(0.003)}.dup, i_freq) * env;

    Out.ar(out, klank);
}).add;
)

// nothing special yet, just using the default set of harmonics.
a = Synth(\help_Klank, [\i_freq, 300]);
b = Synth(\help_Klank, [\i_freq, 400]);
c = Synth(\help_Klank, [\i_freq, 533.33]);
d = Synth(\help_Klank, [\i_freq, 711.11]);
a = Synth(\help_Klank, [\i_freq, 500, \harm,Array.geom(4, 1, 1.61)]);

(
var winenv;
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

Ndef(\sin_grain_test, {arg gate = 1, amp = 1, envbuf, trigRate = 10, dur =0.1;
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = 0;//MouseX.kr(-1, 1);
    // use WhiteNoise and mouse y to control deviation from center pitch
	trigRate = MouseX.kr(1, 100);
    freqdev = BrownNoise.kr(MouseY.kr(0, 1000)).poll;
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: 2);
    Out.ar(0,
		        GrainSin.ar(2, Dust.kr(trigRate), dur, 440 + freqdev, pan, envbuf) * env) * 0.1
    }).play;

)
Ndef(\sin_grain_test).set(\trigRate, 100);
Ndef(\sin_grain_test).set(\dur, 0.02);
Ndef(\sin_grain_test).set(
Ndef(\sin_grain_test).set(
Ndef(\sin_grain_test).set(
s.scope
// use built-in env
x = Synth(\sin_grain_test, [\envbuf, -1])
z.plot
// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);

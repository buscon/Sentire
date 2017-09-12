(
Ndef(\pad, { arg  freqMul = 0.6,  master_vol = 0.5, volume = 0.5;
	var sig;
	var scale = Scale.choose;
	var freq = { [ 261.6255653006, 321.50005749269, 644.02146481203, 834.95751705018].choose * LFNoise2.kr(1,0.01,1) }!48;
        var gen = LFSaw.ar(freq* freqMul) * 0.1;
        var fmodì = LFCub.kr(1/12).range(1, 2); // modulate filter with mouse
        var rqmod = LFNoise2.kr(1/8).range(0.1,1.0);
	scale.name.postln;

	sig = RLPF.ar(gen, freq * fmod , rqmod) * master_vol * Lag3UD.kr(volume, 0.5, 0.2);
	sig = Mix.ar(sig)!2 * 0.1;
	//sig = AdCVerb.ar( sig, 4)* 0.015;
		//sig = GVerb.ar(sig, 300, 1) * 0.03;
	//sig = Mix.ar(sig);


	sig = Limiter.ar(sig);

	Out.ar(0, sig);
}).play;


)
a = Scale.choose.name
a.name
Scale.directory
(Scale.ahirbhairav.ratios * 60)
[60,64,65,67].midicps
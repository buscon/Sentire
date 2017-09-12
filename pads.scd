(
Ndef(\pad_wu,{arg vol=0.25, dev = 0, source =0;
	var sig, freq=100, wave = LFSaw;
	//source = MouseX.kr(0, 1);
	freq = Array.fill(10, freq * ({rrand(0.95,1.05) * [1,2,3,4,16].wchoose([0.3,0.1,0.15,0.15,0.3])} ) );// * LFNoise2.ar(LFNoise0.kr(1, 0.5, 0.6).poll, 0.1, 1);

	freq.postln;

	sig=Mix(wave.ar(freq,0,0.1),wave.ar(2*freq,0,0.1),SinOsc.ar(3*freq,0,0.3))!2;
	sig = LPF.ar(sig, 3000);
	//	MouseX.kr()
		//EnvGen.ar(Env.circle([0.5,1,0.5],[0.2,0.2]))
	sig=RLPF.ar(	sig	,source.linexp(0, 1, 100, 2000), source.linexp(0, 1, 0.2, 0.5), 0.4)!2;
	Out.ar(0,vol*sig);

}).play;

Ndef(\pad_wi,{arg out=0,d=0,a=0.2,amp=0.01, source = 0;
    var sig=0;
	var f;
    var sig2;
    //var env=EnvGen.kr(Env.linen(6,7,10),doneAction:2);
    var amplitude;
    var trig;
    var trigCon;
    var timer;
	//source =  MouseX.kr();
	f=Array.geom(16, 100, 1.1 * source.linlin(0,1, 0.9, 1.1)) ;
//	f.poll;
	sig2=SinOsc.ar(f[15],0,0.08);

    sig=Array.fill(16,{|n|
		[// SinOsc.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,a),
						VarSaw.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,0.5,a),

			VarSaw.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,0.5,a),
			LFTri.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,a),
			WhiteNoise.ar(0.001)].wchoose([0.33,0.33,0.33,0.01])
	});
    sig=Splay.ar(sig,0.5);



    Out.ar(out,((sig+sig2))!2);

}).play;


Ndef(\padnoise, {|source = 0,value = 0.5|
		var vol = 0.5,
	dur = 8,
	num = 8,
	root =24,
	freq = (100+root).midicps,
	spread = 0.5,
	attack =0.3,
	harm = Array.geom(num, 1, 1.5),
	harma = Array.geom(num, 0.5, 0.8),
	detune,  bandwidth,
		generator, snd;

	//value = MouseX.kr();
	detune = Array.fill(num, { value.linlin(0, 1, 0.21,1.0) * LFNoise2.kr(1,0.01,1) });

	source = PinkNoise.ar;
	bandwidth = value.linlin(0, 1, 0.0001,0.01);
			 generator =
				SinOsc.ar(freq*harm*detune, mul:harma*0.05).scramble
	+
	Resonz.ar(source, freq*harm*detune, bandwidth, mul:harma).scramble * 50
			;
	generator = RLPF.ar(generator, freq/8, 0.25);
			 snd = Splay.ar(generator,spread);
			snd = snd;// * LFGauss.ar(dur, attack, loop:1, doneAction:2);
    snd = Compander.ar(snd, snd,
        thresh: 0.5,
		slopeBelow: 1,
        slopeAbove: 0.4,
        clampTime: 0.01,
        relaxTime: 0.01
    );

	//snd = GVerb.ar(snd, 100) * 0.1;
	Out.ar(0, snd * vol);

}).play;


)


(
Ndef(\pad1,{arg vol=0.25, dev = 0, source =0;
	var sig, freq=100, wave = LFSaw,mulH;
	source = MouseX.kr(0, 1);
	if(source > 0.8, {mulH = rrand(500, 1000).postln});
	sig = wave.ar(HenonC.ar(freq, source.linexp(0, 1, 1.4, 0.2).poll, 0.3)* 800, 0, 0.5) ;
	//sig=RLPF.ar(	sig	,source.linexp(0, 1, 100, 2000), source.linexp(0, 1, 0.2, 0.5), 0.4)!2;
	Out.ar(0,vol*sig);

}).play;
)
(
Ndef(\change_freq,{arg vol=0.25;
	var sig, freq=300, source, trig;

	source = MouseX.kr(0, 1);
	 trig = source > 0.8;
	freq = TRand.kr(500, 1000, trig);
	//if(source > 0.8, {freq = rrand(500, 1000).postln});
	sig = Array.fill(6, {freq = freq * rrand(0.999,1.001);SinOsc.ar([freq, source.linlin(0, 1, freq, freq+8)], 0, 0.5)}) ;
	sig = Splay.ar(sig);
	Out.ar(0,vol*sig);

}).play;
)

{ SinOsc.ar(HenonC.ar(40, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*800+900)*0.4 }.play(s);
(
Ndef(\pad_wu,{arg vol=0.25, dev = 0, source =0;
	var sig, freq=100, wave = LFSaw;
	//source = MouseX.kr(0, 1);
	freq = Array.fill(10, freq * ({rrand(0.95,1.05) * [1,2,3,4,16].wchoose([0.3,0.1,0.15,0.15,0.3])} ) );// * LFNoise2.ar(LFNoise0.kr(1, 0.5, 0.6).poll, 0.1, 1);

	freq.postln;

	sig=Mix(wave.ar(freq,0,0.1),wave.ar(2*freq,0,0.1),SinOsc.ar(3*freq,0,0.3))!2;
	sig = LPF.ar(sig, 3000);
	//	MouseX.kr()
		//EnvGen.ar(Env.circle([0.5,1,0.5],[0.2,0.2]))
	sig=RLPF.ar(	sig	,source.linexp(0, 1, 100, 2000), source.linexp(0, 1, 0.2, 0.5), 0.4)!2;
	Out.ar(0,vol*sig);

}).play;
)

(
Ndef(\pad_wi,{arg out=0,d=0,a=0.2,amp=0.01, source = 0;
    var sig=0;
	var f;
    var sig2;
    //var env=EnvGen.kr(Env.linen(6,7,10),doneAction:2);
    var amplitude;
    var trig;
    var trigCon;
    var timer;
	//source =  MouseX.kr();
	f=Array.geom(16, 100, 1.1 * source.linlin(0,1, 0.9, 1.1)) ;
//	f.poll;
	sig2=SinOsc.ar(f[15],0,0.08);

    sig=Array.fill(16,{|n|
		[// SinOsc.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,a),
						VarSaw.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,0.5,a),

			VarSaw.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,0.5,a),
			LFTri.ar(f[n]+SinOsc.ar(f[n]*10,0,d),0,a),
			WhiteNoise.ar(0.001)].wchoose([0.33,0.33,0.33,0.01])
	});
    sig=Splay.ar(sig,0.5);



    Out.ar(out,((sig+sig2))!2);

}).play;
)


(
Ndef(\padnoise, {|source = 0,value = 0.5|
		var vol = 0.5,
	dur = 8,
	num = 8,
	root =24,
	freq = (100+root).midicps,
	spread = 0.5,
	attack =0.3,
	harm = Array.geom(num, 1, 1.5),
	harma = Array.geom(num, 0.5, 0.8),
	detune,  bandwidth,
		generator, snd;

	//value = MouseX.kr();
	detune = Array.fill(num, { value.linlin(0, 1, 0.21,1.0) * LFNoise2.kr(1,0.01,1) });

	source = PinkNoise.ar;
	bandwidth = value.linlin(0, 1, 0.0001,0.01);
			 generator =
				SinOsc.ar(freq*harm*detune, mul:harma*0.05).scramble
	+
	Resonz.ar(source, freq*harm*detune, bandwidth, mul:harma).scramble * 50
			;
	generator = RLPF.ar(generator, freq/8, 0.25);
			 snd = Splay.ar(generator,spread);
			snd = snd;// * LFGauss.ar(dur, attack, loop:1, doneAction:2);
    snd = Compander.ar(snd, snd,
        thresh: 0.5,
		slopeBelow: 1,
        slopeAbove: 0.4,
        clampTime: 0.01,
        relaxTime: 0.01
    );

	//snd = GVerb.ar(snd, 100) * 0.1;
	Out.ar(0, snd * vol);

}).play;

)


(
~pad = Ndef(\pad, { arg  freqMul = 0.6,  master_vol = 0.3, volume = 0.2, scale_freq = 0.5, filter_mod = 1, rq_mod = 1,  volume2 = 1, pan =0;
	var sig, freq, gen, fmod, rqmod, trig;
	trig = MouseX.kr() > 0.9;
	scale_freq = TRand.kr(0.1, 0.9, trig);

	freq = { ([60, 67, 75, 89, 106].choose.midicps * VarLag.kr(scale_freq.poll, 1, 4) )* LFNoise2.kr(1,0.01,1) }!24;
	gen = SinOscFB.ar(freq* freqMul, 1) ;
		gen = RLPF.ar(gen, 2000, 0.3);

	filter_mod = MouseX.kr(0.1, 4.5, 1); rq_mod = MouseY.kr(0.1, 2.0);
	fmod = LFCub.kr(1/12).range(1, 1.5) * filter_mod; // modulate filter
	rqmod = LFNoise2.kr(1/8).range(0.5,1.2) * rq_mod;
	sig = gen;
	sig = Resonz.ar(sig, (freq.mean * fmod) ,rqmod, rqmod.reciprocal * 0.5);

	sig = Splay.ar(sig, 1, 3, LFNoise0.kr(3)) *
//	(volume * volume2)
	Lag3UD.kr(volume * volume2, 0, 0.5)
	;

	sig = GVerb.ar(sig, 200, 5, 0.7, 0.5, 50) * 0.1;
//	sig = AdCVerb.ar(sig, 3) * 0.2;
//	sig = FreeVerb.ar(sig, 1, 0.9);
//	sig = Mix.new(sig);

	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).play;


)
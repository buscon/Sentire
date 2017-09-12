/*
Ndef(\test_touch, {|freq = 100, vol = 0|
	var  ausgang;
	//freq = MouseX.kr(100, 5000);
	ausgang = SinOsc.ar( freq, 0, 0.2) * vol;

	Out.ar(0,  ausgang!2);
}).play;

~ampTable = Signal.hanningWindow(1024).squared;
~freqTable = Signal.newClear(1024).waveFill({ arg i; 0.5 ** i * 20000 }, 0, 10);

~b1 = Buffer.loadCollection(s, ~freqTable);
~b2 = Buffer.loadCollection(s, ~ampTable);

Ndef(\shepT, {arg proximity = 0.5, volume = 0, freq_mul = 1.5;
	var freqs, amps, phasor, ratescale, rate, phases, sig;
	ratescale = 1024 / 44100 / 10;
	rate = 0.1;	// once per 10 sec
	//proximity = MouseX.kr(0,1).poll;
	phasor = K2A.ar(proximity.linlin(0, 1, 1024*freq_mul, 2048));//phasor = Phasor.ar(0, rate * ratescale, 0, 1024).poll;
	phases = (0..9) * 0.1 * 2048 + phasor;

	freqs = BufRd.ar(1, ~b1.bufnum, phases);
	amps = BufRd.ar(1, ~b2.bufnum, phases);

	sig = Mix.ar(LFSaw.ar(freqs) * amps) * 0.1;
	sig = LPF.ar(sig, 1000);
	sig = RHPF.ar(sig, proximity.linlin(0, 1, 3000, 100), 0.3);

	Out.ar(0, sig * volume);
}).play;
*/
Ndef(\pulse,{ arg root_freq = 180, freq_mod = 0, delayTime = 0.03,amp = 1.0,attack = 0.01, freq_dev = 0.1, volume = 0;
	var out,out2,env, freq;
	// with touch, trigger a sequence of frequencies
	freq = root_freq + freq_mod;
	delayTime = delayTime * LFNoise2.kr(1).range(0.9, 1.1);

	z = SinOsc.ar(freq * LFNoise2.kr(1).range( 1- freq_dev, 1+freq_dev),0,0.7);
	a = Pan2.ar(ToggleFF.ar(TDelay.ar(z,delayTime)) * SinOsc.ar(freq),
	         SinOsc.kr(3,0), 0.6);
	out = Pan2.ar(z, SinOsc.kr(5,1.0pi), 0.1 ) + a;
	out = out ;
	out = out.clip2(1) * 0.25 * volume;

	Out.ar(0, out);
}).play;

// modulating formant frequency
Ndef(\mod_bubble, { arg proximity = 0, freq = 500, freq_mod =0, volume = 0.5, decaytime = 0, delaytime = 0;
    var in, sig;
//	proximity = MouseX.kr(0.0, 1.0);
	freq = freq + proximity.linlin(0, 1, 0, 100);
    in = Blip.ar(
//		SinOsc.kr(5,0,20,10).poll,
		proximity.linlin(0, 1, 1, 10) + freq_mod,
		200, 0.1);
   sig =  Formlet.ar(in, freq, 0.005, 0.04);
	sig = LPF.ar(sig, freq*2,  0.5);
	sig = sig + CombC.ar(sig, 1, (proximity.linlin(0, 1, 0.5, 0.3) + (-1 * delaytime))
		//.poll(label:"delaytime")
		, (proximity.linlin(0, 1, 5, 2) + decaytime)
		//.poll(label:"decaytime")
		, 0.5);
	sig = Pan2.ar(sig, SinOsc.kr(5,1.0pi), 0.8);

	sig = sig *proximity.linlin(0.0, 0.1, 0.0, 1.0) * volume;
	Out.ar(0, sig);
}).play;
//([86, 82, 79, 73, 72, 70, 66, 60, 59,58,55, 53 ]/53).reverse

Ndef(\softSin, { arg proximity = 0.38, root = 53, volume = 0, lfoRate = 1, lfoAmt = 0, which = 0;
		var sig, scale, list, ratios, ratios_reversed;

	//proximity = MouseX.kr(0, 1);
	// desc scale b (Boram)
	//ratios = [78,  76, 70, 64, 56, 52, 49, 43].reverse/root;
	// desc scale a (Boram)
	//ratios = [86, 82, 79, 73, 72, 70, 66, 60, 59,58,55, 53 ]/53;//Scale.major.ratios;
//	ratios = [86, 82, 79, 73, 72, 70, 66, 60, 59,58,55, 53 ]/53;//Scale.major.ratios;

	ratios = [86, 82, 79, 73, 72, 70, 66, 60, 59,58,55, 53 ]/53;//Scale.major.ratios;
	ratios = SelectX.kr(which, [ratios, ratios.reverse]);

	scale = ratios;
		list = Array.series(scale.size + 1, 0, 1/scale.size);
		sig =
//	SinOsc.ar(
		LFTri.ar(
//		LFCub.ar(
		(scale * root).midicps
		* LFNoise2.ar(lfoRate, lfoAmt, 0.5).abs;
		,
			0,

		Array.fill(scale.size, {arg i;
			//(proximity + list[i])
			proximity.linlin(list[i], list[i+1], 0, 0.1 * proximity)
		})


			);
	sig = RLPF.ar(sig, (
		// reversed
	//
// not reversed

			SelectX.kr(which, [proximity.linlin(0, 1, 3100, 400), proximity.linlin(0, 1, 150, 1100)])
		* LFCub.kr(1, 0, 0.5).range(0.6, 1)
	)
		, 0.4);
	sig = Mix.ar(sig);
//			sig = Splay.ar(sig);
	sig = Pan2.ar(sig, SinOsc.kr(5,1.0pi), 0.1 );

			Out.ar(0, sig * volume);

	}).play;

Ndef(\crazy_pad, { arg  freqMul = 0.6, freqMul2 = 1, master_vol = 0.5, volume = 0, mulNoiseFreq = 0.5, mulNoiseFreq2 = 0.1;
	var sig;
	var scale = Scale.choose;
	var freq = { [ 261.6255653006, 321.50005749269, 644.02146481203, 834.95751705018].choose  * freqMul2 * LFNoise2.kr(1,0.01 * Lag3UD.kr(mulNoiseFreq + mulNoiseFreq2, 0, 0),1) }!24;
        var gen =  LFSaw.ar(freq* freqMul) * 0.3;
        var fmod = 1;//LFCub.kr(1/12).range(1, 2); // modulate filter with mouse
        var rqmod = LFNoise2.kr(1/8).range(0.1,1.0);

	sig = gen;

	sig = RLPF.ar(sig, (freq * fmod* freqMul *3)  , rqmod) * master_vol * Lag3UD.kr(volume, 0, 0.5);
			sig = Mix.ar(sig)!2 * 0.25;

	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	Out.ar(0, sig);
}).play;

	Ndef(\pad_comfy, {arg root_freq = 0.5, scale_freq = 0.4, touched = 1, proximity = 0;
		var density, env, decay,snd;
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
		var gate = 1;
		env = EnvGen.kr(Env.adsr(0.5,1,1,1,1), gate);
		snd = RLPF.ar(gen, freq * fmod * 0.125, rqmod, 1) * env;
		//	snd = Array.fill(6, CombN.ar(snd, 0.2, {rrand(0.01,0.1)}, 1));
		snd = Splay.ar(snd) * (proximity.linlin(0.05, 0.1, 0, 0.5) + proximity.linlin(0.1, 0.9, 0, 0.5) );



		snd =   Splay.ar(snd);
		Out.ar(0, snd)

	}).play;

Ndef(\blowing, { arg root = 36, touched = 1, proximity = 0;
//	var proximity = MouseX.kr(0,1).round(0.001);

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
	snd = Splay.ar(snd, spread);
		snd = Splay.ar(snd, spread) *0.25;
	snd = LeakDC.ar(snd) * (proximity.linlin(0.05, 0.1, 0, 0.5) + proximity.linlin(0.1, 0.9, 0, 0.5) );
	snd = Limiter.ar(snd, 0.9);
	Out.ar(0, snd);
}).play;

/*
Ndef(\vinylCrackling, { arg out = 0, proximity, root_freq = 0, noiseFreqMul = 1, volume = 0, which = 0, combSpeed = 0.5;

	var pop, imp, modImp, midNoise, hiNoise, loNoise, loopTime, numChan,w, x, y, trigPop, sig, combSig;



	loopTime = 8;

	numChan = 2;


	//Harder pops

	pop = TDuty.ar(Dseq({ 1.0.bilinrand.abs } ! loopTime, inf));
//	proximity = MouseX.kr(0.0, 1);
	trigPop = Impulse.ar(proximity.linlin(0.0, 1.0, 1.0, 5)) + Dust.ar(proximity.linlin(0.0, 1.0, 0.1, 10));
//	trigPop = Impulse.ar(5) + Dust.ar(5);
//	pop = Resonz.ar(Decay.ar(trigPop, TRand.ar(0.001, 0.1, pop)), Demand.ar(pop, 0, Dseq({ 7000.bilinrand.abs + 40 } ! 		loopTime, inf)), 0.05, mul: Demand.ar(pop, 0, Dseq({ exprand(0.1, 0.57) } ! loopTime, inf)));
	pop = Resonz.ar(Decay.ar(trigPop, proximity.linlin(0.0, 1.0, 0.001, 0.5)), proximity.linexp(0.1, 1.0, 100, 2000) * noiseFreqMul, proximity.linexp(0.1, 1.0, 0.5, 0.07), mul: proximity.linexp(0.1, 1.0, 0.5, 2.0));

	pop = LeakDC.ar(pop)!2 * 0.5;

	#w, x, y = PanB2.ar(pop, Demand.ar(pop, 0, Dseq({ 1.0.rand2 } ! loopTime, inf)));



	//Softer, highpass filtered impulses

	imp = { arg i; HPF.ar(LPF.ar(Dust2.ar(proximity.linlin(0.0, 1.0, 0.1, 10)), 8000.0), 6000.0 * noiseFreqMul, WhiteNoise.ar(1)) *proximity.linlin(0.0, 1.0, 0.5, 2.0) } ! numChan;



	//Faster, modulated lowpass filtered impulses

	modImp = LPF.ar(Dust.ar(LFDNoise3.ar(1).exprange(100, 500), LFDNoise3.ar(10).exprange(0.01, 0.07)), 9000.0 * noiseFreqMul, proximity.linlin(0.0, 1.0, 0.1, 1.0)) ! numChan;



	//Mid frequency modulated noise background

	midNoise = LPF.ar(GrayNoise.ar(LFDNoise3.ar(60)) * WhiteNoise.ar(0.009), 12000.0 * noiseFreqMul, proximity.linlin(0.0, 1.0, 0.1, 1.0)) ! numChan;



	//High frequency modulated noise background

	hiNoise = HPF.ar(LPF.ar(GrayNoise.ar(LFDNoise3.ar(60)) * WhiteNoise.ar(0.01), 14000.0 * noiseFreqMul, proximity.linlin(0.0, 1.0, 0.1, 1.0)), 8000.0) ! numChan;



	//Low frequency modulated noise background

	loNoise = LPF.ar(BrownNoise.ar(PinkNoise.ar.range(0.001, 0.02)), 1200 * noiseFreqMul,proximity.linlin(0.0, 1.0, 0.1, 1.0) ) ! numChan;

sig = pop + imp + modImp + midNoise + hiNoise +loNoise;
//	sig = Greyhole.ar(sig);
	combSig = Array.fill(6, {CombC.ar(sig, 0.5, SinOsc.kr(LFNoise0.kr(rrand(0.1, 0.5) * combSpeed).exprange(0.1, 2) * combSpeed).exprange(0.3, 0.01)) } );
	sig = SelectX.ar(which, [sig, combSig]);
	sig = LPF.ar(sig, 18000);
	sig = LeakDC.ar(sig);
	Out.ar(out,sig * volume
	//	imp + pop
	//	DecodeB2.ar(numChan, w, x, y) +  imp + modImp + midNoise + hiNoise + loNoise

	);

	}).play;


Ndef(\drone, {| vol = 0, freq_mul = 0.7, lpf_freq = 500, dev =0 |
	var num = 50, ratios, sig;
	num = 50;//MouseY.kr(1,50);//50;
	ratios = Scale.rast.ratios;

	sig = RLPF.ar(Ringz.ar(PinkNoise.ar(0.1),

		[ [ 3332, 3332 ], [ 2055, 2055 ], [ 1255, 1255 ], [ 3535, 3535 ], [ 1302, 1302 ], [ 845, 845 ], [ 834, 834 ], [ 3819, 3819 ], [ 2144, 2144 ], [ 2916, 2916 ], [ 2917, 2917 ], [ 1492, 1492 ], [ 1527, 1527 ], [ 2353, 2353 ], [ 1445, 1445 ], [ 1304, 1304 ], [ 2532, 2532 ], [ 2170, 2170 ], [ 1907, 1907 ], [ 3156, 3156 ], [ 1091, 1091 ], [ 3657, 3657 ], [ 3996, 3996 ], [ 3035, 3035 ], [ 3300, 3300 ], [ 3394, 3394 ], [ 1646, 1646 ], [ 3263, 3263 ], [ 1976, 1976 ], [ 1049, 1049 ], [ 3534, 3534 ], [ 2587, 2587 ], [ 3495, 3495 ], [ 1232, 1232 ], [ 1383, 1383 ], [ 967, 967 ], [ 2541, 2541 ], [ 2326, 2326 ], [ 3105, 3105 ], [ 3644, 3644 ], [ 1130, 1130 ], [ 3736, 3736 ], [ 2858, 2858 ], [ 2892, 2892 ], [ 1429, 1429 ], [ 3956, 3956 ], [ 1239, 1239 ], [ 1813, 1813 ], [ 1641, 1641 ], [ 3055, 3055 ] ]

		* freq_mul * 1.gauss(dev) , {rrand(0.1, 1)}.dup(num), 1).mean, lpf_freq)  * 1;

	Out.ar(0, sig * vol);


}).play;


Ndef(\pad_wu,{arg vol=0, dev = 0, source =0;
	var sig, freq=100, wave = LFSaw;
	//source = MouseX.kr(0, 1);
	freq = Array.fill(10, freq * ({rrand(0.95,1.05) * [1,2,3,4,16].wchoose([0.3,0.1,0.15,0.15,0.3])} ) );// * LFNoise2.ar(LFNoise0.kr(1, 0.5, 0.6).poll, 0.1, 1);


	sig=Mix(wave.ar(freq,0,0.1),wave.ar(2*freq,0,0.1),SinOsc.ar(3*freq,0,0.3))!2;
	sig = LPF.ar(sig, 3000);
	//	MouseX.kr()
		//EnvGen.ar(Env.circle([0.5,1,0.5],[0.2,0.2]))
	sig=RLPF.ar(	sig	,source.linexp(0, 1, 100, 2000), source.linexp(0, 1, 0.2, 0.5), 0.4)!2;
	Out.ar(0,vol*sig);

}).play;

Ndef(\pad_wi,{arg out=0,d=0,a=0.2,amp=0.01, source = 0, vol =0;
    var sig=0;
	var f;
    var sig2;
    //var env=EnvGen.kr(Env.linen(6,7,10),doneAction:2);
    var amplitude;
    var trig;
    var trigCon;
    var timer;
	var freq_shift;
	//	 trig = source > 0.8;
	//freq_shift = TRand.kr(0.9, 1.1, trig);
	//source =  MouseX.kr();
	f=Array.geom(16, 100,  1.1 * source.linlin(0,1, 0.9, 1.1)) ;
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



    Out.ar(out, vol * ((sig+sig2))!2);

}).play;


Ndef(\padnoise, {|vol = 0, source = 0,value = 0.5, root = 24|

	var dur = 8,
	num = 8,
	freq = (100+root).midicps,
	spread = 0.5,
	attack =0.3,
	harm = Array.geom(num, 1, 1.5),
	harma = Array.geom(num, 0.5, 0.8),
	detune,  bandwidth,
		generator, snd;

	//value = MouseX.kr();
	detune = Array.fill(num, { value.linlin(0, 1, 0.21,0.41) * LFNoise2.kr(1,0.01,1) });

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
        thresh: 0.3,
		slopeBelow: 1,
        slopeAbove: 0.4,
        clampTime: 0.01,
        relaxTime: 0.01
    );

	//snd = GVerb.ar(snd, 100) * 0.1;
	Out.ar(0, snd * vol);

}).play;


~fw = Ndef(\freq_wander, { arg out=0, lo=70, hi=80, step=1, rate=10, volume=0, volume2 = 1, pan=0, lgate = 1, scale_val = 1, scale_tones = 1, deviation = 1, freq_scale = 1, bwr = 0.2, lowPass_scale = 1;
	var output, freq, num_comb, num_tones, freq_list, bpassFreq;
	num_comb = 24;
	num_tones = num_comb*2;
	//deviation = MouseX.kr(1, 150);step = MouseX.kr(0.01, 10);
	freq = Demand.ar(Impulse.ar(rate), 0,
//		Dbrown(lo, hi)
		Dbrown(lo, hi, step)
	).midicps * scale_val;
	bpassFreq = freq * 0.45232423;
//	freq = Demand.ar(Impulse.ar(rate), 0, SinOsc.ar(0.02).range(lo, hi)).midicps * scale_val;

	output = LPF.ar(
		//Mix.new(VarSaw.ar((freq + [0, -0.2, 0.2, 0.4, -0.4]).poll, 0, 0.8, 0.1)),
		Mix.new(VarSaw.ar(((freq  + Array.fill(num_tones, {gauss(0.0, 0.5) * deviation}))) * freq_scale, 0, 0.8, Array.fill(num_tones, {rrand(0.01, 0.1)}) )), LFNoise2.ar(0.5).range((freq * 0.634423), (freq* 1.45)) * lowPass_scale, 0.5
	);

	output = Mix.ar(Array.fill(num_comb,{ CombN.ar(output, 0.02, rrand(0.001, 0.02), 0.5, 1/num_comb) })) *1 * Lag3UD.kr(volume * volume2, 0, 0.5 );
//	output = Resonz.ar(output, bpassFreq, bwr, 10);
	//output = LPF.ar(output, 1000);
	output = LeakDC.ar(output);
//	output = GVerb.ar(output, 200, 3):
	output = Mix.new(output);

	OffsetOut.ar(out, Limiter.ar(Pan2.ar(output, pan, 1), 0.9));
}, [\ir]).play;

Ndef(\fm_perc, {arg volume = 0, speed = 5, freq = 0.1, freq_root = 0.1;
	var sig, fEnv;

	speed = Impulse.kr(speed);
	fEnv = EnvGen.kr( Env.perc(0.01, 0.1), gate: speed, levelScale: 900, levelBias: 50 );

	sig = PMOsc.ar((freq + freq_root) * fEnv, 1, 12, mul: EnvGen.kr(Env.perc(0, 3), speed)* 0.1)!2;

	sig = LeakDC.ar(sig) * volume;
	Out.ar(0, sig );
}).play;

*/


//~gran = Synth(\granulator, [\volume, 0, \bufnum, ~clara1]);
//~glitch = Synth(\glitch_sounds);
//~cnoise = Synth(\noisePlayerContinuous, [\vol, 0]);
//~natteredMoon = Synth(\wedSynth);

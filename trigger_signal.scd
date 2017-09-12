(
// triggering sinus
Ndef(\trigger_sin, {|bufnum = 3, source = 0, pos =0, bgate = 1, rate =1|
	var  trig, aEnv, aEnvNoise, fEnv, amp =0.2, ausgang, pan, freq,speed;


	source= MouseX.kr(0,1).round(0.05);//LFNoise0.ar(100);
//source= LFNoise0.kr(10).abs.poll;
	speed = StdDevUGen.kr(source, 40).poll;
	trig= Trig1.kr((source- Delay1.kr(source)).abs , 0.0001);

	aEnv = EnvGen.ar(Env.perc(0.05, 0.1), gate: trig);
	pan = Dwhite(-1, 1, inf);
	//freq = Scale.zhi.

	ausgang = aEnv *   Pan2.ar(SinOsc.ar(source.linexp(0, 1, 80, 2000).round(1), mul: 0.5), Demand.kr(trig, 0, pan) )
 * amp;
	Out.ar(0, ausgang);


}).play;
)




(
	Ndef(\upDown, {
		var sig= MouseX.kr(0, 1);
	var dir= sig-Delay1.kr(sig);
	var switch= (dir*4000).clip(-1, 1).round.poll; //-1, 0, or 1 (tune 4000)
	var freq = 600;
	SinOsc.ar( Select.kr(switch, [freq/2 * sig, freq, freq * 1.5* sig]).poll, 0, 0.2 )
}).play
)
)

(

Ndef(\trigger_sin, {|source = 0|
	var  trig, aEnv, aEnvNoise, fEnv, amp =0.2, ausgang;


//	source= MouseX.kr(0,1).round(0.01);//LFNoise0.ar(100);
	source = source.round(0.01);
//source= LFNoise0.kr(10).abs.poll;
	trig= Trig1.ar((source- Delay1.kr(source)).abs , 0.001);

	aEnv = EnvGen.kr(Env.perc(0.05, source.linexp(0, 1, 1, 0.2)), gate: trig);
	aEnvNoise = EnvGen.kr(Env.perc(0.01, 0.1), gate: trig);
	fEnv = EnvGen.kr(
		Env.perc(0.1, source.linexp(0, 1, 0.5, 0.1)), gate: trig,
		levelScale: 100, levelBias: 10
	);

	ausgang = aEnv * ((0.1 * WhiteNoise.ar * aEnvNoise) +
		SinOsc.ar((fEnv * source.linexp(0, 1, 1, 8) * 0.4), 0, 1.5).softclip) * amp;
	Out.ar(0, ausgang!2);
}).play;

)

(

Ndef(\trigger_sample, {|bufnum = 3, source = 0,  bgate = 1, rate =1|
	var  trig, aEnv, aEnvNoise, fEnv, amp =0.2, ausgang, pos;


	source= MouseX.kr(0,1).round(0.01).lag(0.007);//LFNoise0.ar(100);
//source= LFNoise0.kr(10).abs.poll;
	trig= Trig1.kr((source- Delay1.kr(source)).abs , 0.001); //0.001 is duration of trigger signal output

	aEnv = EnvGen.ar(Env.perc(0.01, 1), gate: trig);
	pos = Demand.kr(trig, 0, Dwhite(0, 1, inf));

	ausgang = aEnv *   PlayBuf.ar(1, bufnum,
		//source.linlin(0,1, 0.5, 1.5)
		BufRateScale.kr(bufnum)
		,
		trig,  source.linlin(0, 1.0, 0, BufFrames.kr(bufnum)).poll , 1)
 * amp;
	Out.ar(0, ausgang!2);


}).play;
)
(

Ndef(\trigger_sample, {|bufnum = 7, source = 0,  bgate = 1, rate =1|
	var  trig, aEnv, aEnvNoise, fEnv, amp =0.2, ausgang, pos;


	source= MouseX.kr(0,1).round(0.01);//LFNoise0.ar(100);
//source= LFNoise0.kr(10).abs.poll;
	trig= Trig1.kr((source- Delay1.kr(source)).abs, 0.01); //0.001 is duration of trigger signal output

	aEnv = EnvGen.ar(Env.perc(0.1, 1), gate: trig);
	pos = Demand.kr(trig, 0, Dwhite(0, 1, inf));

	ausgang =     aEnv *        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * source.linexp(0, 1, 0.5, 1.5), trig, source.round(0.1).linlin(0, 1.0, 0, BufFrames.kr(bufnum)).poll, 1)

 * amp;
	Out.ar(0, ausgang!2);


}).play;
)
SynthDef(\help_PlayBuf, { arg out=0, bufnum=7;
    var trig;
    trig = Impulse.kr(MouseY.kr(0.5, 200, 1));
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), trig, MouseX.kr(0, BufFrames.kr(bufnum)), 1)
    )
}).play(s, [\out, 0, \bufnum, b])

{ Pan2.ar(Mix(SinOsc.ar(200 + [0, 7])), 0.0, 0.1) }.play;
(
960277 - 960000
Env.adsr(1e-8,1e-6,0.75,0.125).plot
(
// Init synth
Ndef(\simpSaw1, {|freq = 100, gate=1|
	var adsr = EnvGen.ar(Env.adsr(0.2,1e-6,0.75,0.125), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 12, detune2 = 8;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var lfo = SinOsc.ar(3.rand, 0, 0.1).range(0,1);
//		LFSaw.ar(m * freq/2);
		DelayC.ar(LFSaw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	var snd = BLowPass4.ar(osc1, 800, 0.5, 0.5) ;
	Out.ar(0, Splay.ar(snd*adsr));

}).play;
)
// build this with the 	trig= Trig1.ar((source- Delay1.kr(source)) , 0.01); system?
{ LFPulse.ar(MouseX.kr(1, 30, 1).poll).lag(0.05) * Pan2.ar(SinOsc.ar(100, mul: 0.1), 0.0) }.play;
{ LFPulse.ar(MouseX.kr(1, 30, 1).poll).lag(0.05) * Pan2.ar(SinOsc.ar(100, mul: 0.1), 0.0) }.play;



s.scope
6.0364e-08
(0.3421123.rand * 100).asInt
Ndef(\trigger_sin).set(\source, 1);
Ndef(\trigger_sin).set(\source, 2);
{SinOsc.ar(300+(200*Latch.ar(SinOsc.ar(13.3), Impulse.ar(10))))*0.2}.play

{Latch.ar(SinOsc.ar(233), Impulse.ar(10).poll)}.play

{Latch.ar(SinOsc.ar(533, 0, 0.5), VarianceUGen.kr( Slope.kr(MouseX.kr(0, 1)), 3).linlin(0, 0.00001, 0, 1))) )}.play
NodeProxy.control

a = NodeProxy(s); a.play;
a.source = { Splay.ar(Blip.ar(\freq.kr(18 ! 4))) * 0.2 };
a.set(\freq, [1, 3, 56, 13]);
a.set(\freq, 0);
a.clear
a.source = { Splay.ar(SinOsc.ar(LFSaw.ar(\freq.kr(18 ! 4)) * 250 + 400)) * 0.2 };
b = NodeProxy(s); b.source = { MouseX.kr(0, 3) *  [1, 3, 56, 13] };
a.set(\freq, b);
a.clear; b.clear;
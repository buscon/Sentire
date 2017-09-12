//set a fundamental frequency
~f = {70}
//a fixed pitch sine wave, using a fundamental frequency
(
~sin = {SinOscFB.ar([~f,~f*1.01],0.7,0.3)};
~sin.play;
)
//4 saw waves that are modulated by LFNoise1 Ugens and arranged around the stereo field
//the frequency of the saw waves is a LFNoise1 that is ranged between the fundamental and ten times the fundamental
70*0.001
g.gui
Ndef(\saws).set(\root_freq, 70);
Ndef(\saws).set(\root_freq, 80);
Ndef(\saws).set(\root_freq, 100);

Ndef(\saws).set(\lfo_speed, 0.3);

Ndef(\saws).set(\lfo_speed, 50);

(
Ndef(\saws, {arg root_freq = 70, lfo_speed = 0.3;
	var ausgang, lfo, proximity;
	proximity = MouseX.kr(0, 1);
	lfo = {LFDNoise1.kr(proximity.linlin(0.9, 1.0, 0.3, LFNoise2.kr(1).range(0.5, 5).poll)).range(root_freq * proximity.linlin(0, 1, 1, 5), root_freq* proximity.linlin(0, 1, 1, 20))};
	ausgang = LFSaw.ar(Array.fill(4,lfo),0.3);
		ausgang = DFM1.ar(ausgang, lfo*0.5, lfo*0.01);
	ausgang = RLPF.ar(ausgang, lfo*0.5, lfo*0.01);

	ausgang = Splay.ar(ausgang);
	ausgang = LeakDC.ar(ausgang) * 0.5;
	Out.ar(0, ausgang);
}).play;
)
b = Buffer.readChannel(s, "/Users/marcello/Music/Samples/SonarQuartett/string_test.aiff", channels:[0]);
[800, 1071, 1153, 1723]*0.25
([800, 1071, 1153, 1723].normalize * 800) + 200
(
Ndef(\saws, {arg root_freq = 70, lfo_speed = 0.3, buf = b;
	var ausgang, lfo, proximity;
	proximity = MouseX.kr(0, 1);
	lfo = {LFDNoise1.kr(proximity.linlin(0.9, 1.0, 0.3, LFNoise2.kr(1).range(0.5, 5).poll)).range(root_freq * proximity.linlin(0, 1, 1, 5), root_freq* proximity.linlin(0, 1, 1, 20))};
	ausgang = PlayBuf.ar(1, b.bufnum, 1, 0, 1, 1);
	ausgang = GVerb.ar(ausgang, 50, 5, 0.4, 0.7, 40);
	ausgang = Compander.ar(ausgang, ausgang, 0.5);
//	ausgang = BPeakEQ.ar(ausgang, [ 200, 434.88624052004, 505.95882990249, 1000 ], 0.1, 6);
//	ausgang = DynKlank.ar(`[[ 200, 434.88624052004, 505.95882990249, 1000 ], [0.1, 0.1, 0.1, 0.1], [0.1, 0.1, 0.1, 0.1]], ausgang, proximity.linlin(0, 1, 0.5, 2.5)) * 0.1;

	ausgang = PitchShift.ar(ausgang, 0.5, proximity.linlin(0, 1, 0.8, 1.2), proximity.linlin(0.8, 1, 0, 0.2), proximity.linlin(0, 1, 0.0, 1.0) );
	/*
	ausgang = BPeakEQ.ar(ausgang, 443, 0.8, -48);
		ausgang = BPeakEQ.ar(ausgang, 1749, 0.1, -48);
		ausgang = BPeakEQ.ar(ausgang, 940, 0.1, -24);
		ausgang = BPeakEQ.ar(ausgang, 2092, 0.1, -48);
*/
//	ausgang = DynKlank.ar(`[[ 200, 434.88624052004, 505.95882990249, 1000 ], {rrand(0.2, 1.0)}!4, {rrand(0.2, 1.0)}!4], ausgang, proximity.linlin(0, 1, 0.5, 1.5));
//		ausgang = DFM1.ar(ausgang, lfo*0.5, lfo*0.01);
	ausgang = RLPF.ar(ausgang, proximity.linexp(0, 1, 150, 2500).poll, 0.2);
//	ausgang = Ringz.ar(ausgang, proximity.linexp(0, 1, 200, 6000), 0.1, 0.1);
//	ausgang = Compander.ar(ausgang, ausgang, 0.5);

	ausgang = Splay.ar(ausgang);
	ausgang = LeakDC.ar(ausgang) * 0.25 *proximity.linlin(0, 0.1, 0, 1);
	ausgang = Limiter.ar(ausgang, 0.9);
	Out.ar(0, ausgang);
}).play;
)

~lfn1.play;
)
//now round this LFNoise1 to the fundamental frequency to get the frequency to sweep the harmonic frequency
(
~lfn1 = {Splay.ar(Saw.ar(Array.fill(4,{LFNoise1.kr(0.3).range(~f,~f*10).round(~f)}),0.3))}
~lfn1.play;
)
//the frequencies are now tuned and sound GREAT (an X/Y scope also looks amazing)
s.scope
//This .range and .round method can be applied to any signal UGen, and also at any multiplication level. Here's a silly extreme example that sounds like shrill bees
(
~lfn1 = {Splay.ar(Saw.ar(Array.fill(40,{SinOscFB.kr(rrand(0.1,0.3),rrand(0.1,2)).range(~f,~f*100).round(~f*4)}),0.4))}
~lfn1.play;
)

//Triggered random frequency changes, using something like TRand
(
~f = {81};
~tChange = {Pulse.ar(TRand.kr(~f,~f*10,Dust.kr(4)).round(~f),SinOsc.kr(0.1).abs,0.6)*SinOsc.ar([~f,~f*1.01])};
~tChange.play;
)

//specific and on-demand frequency changes using Demand.kr - Note that this is *really* verbose for something to be used live.
//I've used an Impulse.kr that recieves the tempo clock as a trigger to show how these synths can be synced to a central tempo clock
//Demand is a lot like having a Pattern inside of a UGen's arguments. Look at the helpfile, it's really cool
(
~f = {66.6};
~dChange = {SawDPW.ar([~f,~f*1.02]*Demand.kr(Impulse.kr(p.clock.tempo*3),0,Dseq([1,8,2,7,3,6,4,5],inf)),SinOsc.kr(40),0.8)};
~dChange.play;
)
//and a kick to show it's synced
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][2],\dur,1,\amp,1);
~k.play;
)
//and more kicks because i really liked this one
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][2],\dur,Pbjorklund2(Pwhite(1,15),16)/6,\amp,2,\rate,Pwrand([1,1.2,1.4,2],[0.6,0.2,0.1,0.1],inf)*1.5);
~k2 = Pbind(\instrument,\bplay,\buf,d["sk"][0],\dur,1,\amp,2);
~k2.play;
)

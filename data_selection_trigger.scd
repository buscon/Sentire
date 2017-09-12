/*
Synth(\noisePlayer, [\cutoff, exprand(80, 300), \vol , 1, \dur , 0.5, \envelope_sel , 0, \attack , 0.01, \decay_time , 0.5, \curve , -16, \mulNoise , 0.5, \bwr , rrand(0.6,2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

Synth(\noisePlayer, [\cutoff, exprand(200, 1000), \vol , 1, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

Synth(\noisePlayer, [\cutoff, exprand(1000, 5000), \vol , 1, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);
Synth(\noisePlayer, [\cutoff, exprand(200, 1000), \vol , 0.5, \dur , 1, \envelope_sel , 1, \attack , 0.01, \decay_time , 1, \curve , -4, \mulNoise , 0.5, \bwr , rrand(0.1,0.4), \which_noise , rrand(4, 5), \speedNoise, rrand(20, 30)]);

Synth(\wavPlayer,  [ \bufnum, ~merleau1, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 1, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(300, 5000), \decay_time , 1, \curve, -8, \vol, 0.25]);

Synth(\wavPlayer,  [ \bufnum, ~rieko1, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 0.5, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 0.5, \curve, -4, \vol, 1]);
*/

(
~pentatonic_ratios = Pxrand(Scale.majorPentatonic.ratios, inf).asStream;
// touch events, change the \root

~data_sel_trigger = { arg val, which, threshold;
	var res,  time, now;

	time = Main.elapsedTime.asInt;
	now = (time.asInt)-0.1;

	res = case
	{ which == 0} {
		~gran.set(\volume, 0);

	}
	{ which == 1} {
		//		Synth(\noisePlayer, [\cutoff, exprand(80, 300), \vol , 1, \dur , 0.1, \envelope_sel , rrand(0, 1), \attack , 0.01, \decay_time , 0.1, \curve , -16, \mulNoise , 0.5, \bwr , rrand(0.6,2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30), \gpos, rrand(-1.0,1.0)]);

	}
	{ which == 2 } {

		Synth(\noisePlayer, [\cutoff, exprand(500, 2000), \vol , 1.5, \dur , 0.1, \envelope_sel , rrand(0, 1), \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30), \gpos, rrand(-1.0,1.0)]);
	}
	{ which == 3 } {

		"freq_root: ".post;
		~freq_root = ~seq_sinTrig.next.postln;
		Synth(\sinTrig, [\freq, ~freq_root *2.5, \volume, 1]);

	}
	{ which == 4 } {
		"freq_root: ".post;
		~freq_root = ~seq_sinTrig.next.postln;
        Synth(\sinTrig, [\freq, ~freq_root * 1, \volume, 0.9]);

		// crackle
		//Synth(\noisePlayer, [\cutoff, exprand(200, 1000), \vol , 0.5, \dur , 0.2, \envelope_sel , 0, \attack , 0.01, \decay_time , 0.2, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.1,0.4), \which_noise , rrand(3, 5), \speedNoise, rrand(20, 30)]);
	}
	{ which == 5 } {
		Synth(\wavPlayer,  [ \bufnum, ~rieko2, \speed , exprand(0.3, 1.2), \pos, [0, 0.05, 0.15, 0.16, 0.21, 0.23, 0.25, 0.27, 0.3, 0.33, 0.37, 0.42, 0.69,0.92, 0.94].choose, \dur , rrand(0.6, 2.0), \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(1000, 5000), \decay_time , 1, \curve, -8, \vol, rrand(2.0, 2.5) , \gpos, rrand(-1.0, 1.0)]);

		~gran.set(\pos, rrand(0.0,0.99).postln;);
		~gran.set(\rate, rrand(0.8, 1.2));

	}
	{ which == 6} {
		~freq_mul_shepT= rrand(0.5, 2.0).postln;
		Ndef(\shepT).set( \freq_mul, ~freq_mul_shepT);

		//	Synth(\wavPlayer,  [ \bufnum, ~rieko2, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 0.5, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 0.5, \curve, -4, \vol, rrand(1.0, 2.0)]);

	}
	{ which == 7} {
		"random_mod: ".post;
		~random_mod = rrand(1, 30).postln;
		Synth(\glitch_sounds_perc, [ \modN, 0.5, \modF, 0.5, \modAmp1, rrand(1, 50), \modAmp2, rrand(1, 50), \modAmp3, rrand(1, 50), \modC, 1, \gpos, 0,  \master_volume, 1.5]);

		//Synth(\wavPlayer,  [ \bufnum, ~rieko3, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 0.2, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 1.5, \curve, -4, \vol, 2.5]);
	}
	{ which == 8} {
		"pos: ".post;
		~gran.set(\pos, [0, 0.23, 0.35, 0.39, 0.46, 0.65, 0.76, 0.8, 0.87, 0.95].choose.postln;);
		~gran.set(\rate, rrand(0.8, 1.2));

		Synth(\wavPlayer,  [ \bufnum, ~clara1, \speed , exprand(0.9, 1.2), \pos, [0, 0.05, 0.15, 0.16, 0.21, 0.23, 0.25, 0.27, 0.3, 0.33, 0.37, 0.42, 0.69,0.92, 0.94].choose, \dur , rrand(0.5, 1.0), \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(1000, 5000), \decay_time , 2, \curve, -8, \vol, rrand(1.0, 1.2) * 0.6 , \gpos, rrand(-1.0, 1.0)]);




	}
	{ which == 9} {
		~granbuf.set(\pos, rrand(0.01, 0.99));
	}
	{ which == 10} {
		//Synth(\skeys, [\atk, exprand(0.01,0.2), \ratio, Scale.whole.ratios.choose,  \amp, { rrand(0.3, 1.0); }.dup(4), \times, {rrand(0.5, 1.0)}.dup(4), \lpf_freq,  exprand(300, 2000), \fq, exprand(0.15, 0.5)]);

	}
	{ which == 11} {
		//Synth(\glitch_sounds_perc, [ \modN, 0.5, \modF, 0.5, \modAmp1, rrand(1, 50), \modAmp2, rrand(1, 50), \modAmp3, rrand(1, 50), \modC, 1, \gpos, 0,  \master_volume, 1.0]);
		Synth(\crazy_pad_perc, [ \freqMul, rrand(0.1, 0.5), \freqMul2, 1, \volume, rrand(0.7, 1.0), \mulNoiseFreq, rrand(0.5, 20), \mulNoiseFreq2, rrand(1, 30), \releaseEnv, 2]);

		Ndef(\crazy_pad).set(\freqMul2,  rrand(1.0, 5.0).postln);
	}
	{ which == 12} {
		//Synth(\skeys, [\atk, exprand(0.01,0.2), \ratio, Scale.whole.ratios.choose,  \amp, { rrand(0.1, 0.4); }.dup(4), \times, {rrand(0.5, 1.0)}.dup(4), \lpf_freq,  exprand(300, 2000), \fq, exprand(0.15, 0.5)]);
		Ndef(\blowing).set(\root, (~pentatonic_ratios.next * 36));


	}
	{ which == 13} {
		~gran.set(\pos, rrand(0.01, 0.99).postln;);
		~gran.set(\rate, rrand(0.95, 1.05));

		~gran.set(\volume, 0.5);

	}
	{ which == 14} {
		var freq;
		freq = rrand(100, 500).postln;
		Ndef(\mod_bubble).set(\freq, freq);
Synth(\mod_bubble, [\freq, freq + rrand(100, 500).postln, \freq_mod, rrand(0, 20), \volume, 0.6]);


	}
	{ which == 15} {
		var dur;
		//	dur = exprand(0.05, 1.0);
		//Synth(\wavPlayer,  [ \bufnum, ~clara2, \speed , 1, \pos, rrand(0.0, 0.9), \dur , dur, \envelope_sel , 1, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , dur, \curve, -4, \vol, 0.5]);

	}
	{ which == 16} {
		var freq;
	//	Synth(\timpano, [\ress, exprand(0.01, 7), \atk, exprand(0.001, 0.4).postln, \choose, [70,90,120, 150].choose]);
	//	Synth(\help_Klank, [\i_freq, (Scale.whole.ratios.choose * 100).postln, \harm,Array.geom(4, 1, 1.61)]);
		freq = exprand(100, 1000).postln;
		Ndef(\pulse).set(\root_freq, freq );
Synth(\pulse_perc).set(\freq, freq);

	}
	{ which == 17} {

	}
	{ which == 18} {
		~natteredMoon.set(\midinote, (Scale.whole.ratios.choose * 36).postln);

	}
	{ which == 19} {
		Ndef(\vinylCrackling).set(\root_freq, rrand(0, 100) );
		Ndef(\vinylCrackling).set(\noiseFreqMul, rrand(0.4, 1.5) );
	}
	{ which == 20} {

	}
	{ which == 21} {

	}
	{ which == 22} {
		Ndef(\padnoise).set(\root, rrand(12, 24) );

	}
	{ which == 23} {
Ndef(\pad_comfy).set(\root_freq, (~pentatonic_ratios.next * 0.75));

	}
	{ which == 24} {

	}
	{ which == 25} {

	}
	;
};
)
/*
~v7
Ndef(\comb).set(\volume,1);
Ndef(\comb).get(\volume);

(
r =Routine {
a = Pseq([ 1, 1.0083727381632, 1.0172433452459, 1.0266414260745, 1.0365983458703, 1.0471473349273, 1.0583235995161, 1.0701644393807, 1.0827093722235, 1.0960002655916, 1.1100814766062, 1.125 ], inf).asStream;
inf.do({
Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, 1, \rate, a.next,				\attack, exprand(0.001, 0.8), \dur, rrand(5.0, 8.0), \pan, rrand(-1.0,1.0), \pos, 0,	\cutoff, 5000,\volumeLag, 6]);
});
};
)
//	Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, 1, \rate, 1,				\attack, exprand(0.001, 0.8), \dur, rrand(5.0, 8.0), \pan, rrand(-1.0,1.0), \pos, 0,	\cutoff, 5000,\volumeLag, 6]);
//Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, 1, \rate, 1.0583235995161,				\attack, exprand(0.001, 0.8), \dur, rrand(5.0, 8.0), \pan, rrand(-1.0,1.0), \pos, 0,	\cutoff, 5000,\volumeLag, 6]);

Synth(\wavPlayer,  [ \bufnum, ~donttouchme, \speed , 1, \pos, 0, \dur , 1, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 1, \curve, -2, \vol, 0.5]);
Synth(\wavPlayer,  [ \bufnum, ~touchme, \speed , 1, \pos, 0, \dur , 1, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 1, \curve, -2, \vol, 0.1]);
*/
//Synth(\wavPlayer,  [ \bufnum, ~rieko1, \speed , 1, \pos, [0, 0.05, 0.15, 0.16, 0.21, 0.23, 0.25, 0.27, 0.3, 0.33, 0.37, 0.42, 0.69,0.92, 0.94].choose, \dur , 1, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(1000, 5000), \decay_time , 1, \curve, -8, \vol, 1]);

//[0, 0.05, 0.15, 0.16, 0.21, 0.23, 0.25, 0.27, 0.3, 0.33, 0.37, 0.42, 0.69,0.92, 0.94]



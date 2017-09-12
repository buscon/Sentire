/*
Synth(\noisePlayer, [\cutoff, exprand(80, 300), \vol , 1, \dur , 0.5, \envelope_sel , 0, \attack , 0.01, \decay_time , 0.5, \curve , -16, \mulNoise , 0.5, \bwr , rrand(0.6,2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

Synth(\noisePlayer, [\cutoff, exprand(200, 1000), \vol , 1, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

	Synth(\noisePlayer, [\cutoff, exprand(1000, 5000), \vol , 1, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);
Synth(\noisePlayer, [\cutoff, exprand(200, 1000), \vol , 0.5, \dur , 1, \envelope_sel , 1, \attack , 0.01, \decay_time , 1, \curve , -4, \mulNoise , 0.5, \bwr , rrand(0.1,0.4), \which_noise , rrand(4, 5), \speedNoise, rrand(20, 30)]);

Synth(\wavPlayer,  [ \bufnum, ~merleau1, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 1, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(300, 5000), \decay_time , 1, \curve, -8, \vol, 0.25]);

Synth(\wavPlayer,  [ \bufnum, ~rieko1, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 0.5, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 0.5, \curve, -4, \vol, 1]);
*/

(
~data_sel_untrigger = { arg val, which, threshold;
	var res,  time, now;

	time = Main.elapsedTime.asInt;
	now = (time.asInt)-0.1;

	res = case
	{ which == 0} {

	}
	{ which == 1} {

	}
	{ which == 2 } {

	}
	{ which == 3 } {

// hi pitch noises

// very hi		Synth(\noisePlayer, [\cutoff, exprand(5000, 10000), \vol , 0.5, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

	}
	{ which == 4 } {

				// crackle
	}
	{ which == 5 } {
		Synth(\wavPlayer,  [ \bufnum, [~rieko1,~rieko3], \speed , exprand(0.3, 1.2), \pos, [0, 0.05, 0.15, 0.16, 0.21, 0.23, 0.25, 0.27, 0.3, 0.33, 0.37, 0.42, 0.69,0.92, 0.94].choose, \dur , rrand(0.6, 2.0), \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(1000, 5000), \decay_time , 1, \curve, -8, \vol, rrand(0.5, 1.0), \gpos, rrand(-1.0, 1.0)]);


	}
	{ which == 6} {


	}
	{ which == 7} {

	}
	{ which == 8} {

			}
	{ which == 9} {
			}
	{ which == 10} {


			}
	{ which == 11} {


			}
	{ which == 12} {



	}
	{ which == 13} {


	}
	{ which == 14} {

	}
	{ which == 15} {

	}
	{ which == 16} {

	//			Synth(\help_Klank, [\i_freq, (Scale.whole.ratios.choose * 100).postln, \harm,Array.geom(4, 1, 1.61)]);

	}
	{ which == 17} {

	}
	{ which == 18} {

	}
	{ which == 19} {

	};
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
*/
//Synth(\granS, [\bufNum, ~b[~sample_id1].bufnum, \volume, 1, \rate, 1.0583235995161,				\attack, exprand(0.001, 0.8), \dur, rrand(5.0, 8.0), \pan, rrand(-1.0,1.0), \pos, 0,	\cutoff, 5000,\volumeLag, 6]);

		//Synth(\wavPlayer,  [ \bufnum, ~touchme, \speed , 1, \pos, 0, \dur , 1, \envelope_sel , 0, \attack , 0.01, \cutoff, 10000, \decay_time , 1, \curve, -4, \vol, 0.5]);



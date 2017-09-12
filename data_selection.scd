(
~data_sel = { arg val, which, threshold;
	var res,  time, now;

	time = Main.elapsedTime.asInt;
	now = (time.asInt)-0.1;

	res = case
	{ which == 0} {

	}
	{ which == 1} {
Synth(\noisePlayer, [\cutoff, exprand(80, 300), \vol , 0.5, \dur , 0.1, \envelope_sel , 1, \attack , 0.01, \decay_time , 0.1, \curve , -16, \mulNoise , 0.5, \bwr , rrand(0.6,2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

	}
	{ which == 2 } {

Synth(\noisePlayer, [\cutoff, exprand(200, 1000), \vol , 0.5, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);
	}
	{ which == 3 } {

// hi pitch noises
	Synth(\noisePlayer, [\cutoff, exprand(1000, 5000), \vol , 0.5, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

// very hi		Synth(\noisePlayer, [\cutoff, exprand(5000, 10000), \vol , 0.5, \dur , 0.1, \envelope_sel , 0, \attack , 0.05, \decay_time , 0.1, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.01,0.2), \which_noise , rrand(0, 2), \speedNoise, rrand(5, 30)]);

	}
	{ which == 4 } {

				// crackle
Synth(\noisePlayer, [\cutoff, exprand(200, 1000), \vol , 0.5, \dur , 0.2, \envelope_sel , 0, \attack , 0.01, \decay_time , 0.2, \curve , -8, \mulNoise , 0.5, \bwr , rrand(0.1,0.4), \which_noise , rrand(3, 5), \speedNoise, rrand(20, 30)]);
	}
	{ which == 5 } {
Synth(\wavPlayer,  [ \bufnum, ~rieko1, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 1, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(200, 5000), \decay_time , 1, \curve, -8, \vol, 0.25]);
	}
	{ which == 6} {

Synth(\wavPlayer,  [ \bufnum, ~rieko2, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 0.2, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 0.2, \curve, -4, \vol, 0.5]);

	}
	{ which == 7} {

Synth(\wavPlayer,  [ \bufnum, ~rieko3, \speed , 1, \pos, rrand(0.0, 0.9), \dur , 0.2, \envelope_sel , 0, \attack , 0.01, \cutoff, rrand(400, 10000), \decay_time , 0.5, \curve, -4, \vol, 0.5]);
	}
	{ which == 8} {
		if(val > threshold, {
			~gran.set(\trigRate, 8);
			~gran.set(\amtRnd, 0.01);
			~gran.set(\dur, 0.2);
						~gran.set(\rndTrigRate, 5);


			"touched--".postln;

		}, {
			~gran.set(\trigRate, 1);
			~gran.set(\amtRnd, 0.01);
						~gran.set(\dur, 0.7);
			~gran.set(\rndTrigRate, 2);
			"untouched--".postln;

		});

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


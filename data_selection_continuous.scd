
(
~data_sel_cont = { arg val, which, threshold, now;
	var res, time;

	//	val.postln;which.postln;

	res = case
	{ which == 0} {
		~gran.set(\volume, 0);
		Ndef(\crazy_pad).set(\volume, 0);
		Ndef(\pad).set(\volume, 0);
		Ndef(\drone).set(\vol, 0);
		//	Ndef(\shepT).set(\volume, 0 );
		Ndef(\softSin).set(\volume, 0);
		//~natteredMoon.set(\volume, 0 );
		Ndef(\mod_bubble).set(\volume, 0 );
		Ndef(\pulse).set(\volume, 0 );
		//	Ndef(\vinylCrackling).set(\volume, 0);

		Ndef(\twinP).set(\proximity, 0);
				Ndef(\blowing).set(\proximity, 0);

		//	Ndef(\sinus).set(\freq, val.linlin(0.1, 1, 200, 700) );

	}
	{ which == 1} {
		var time_elpsd;

		~cnoise.set(
			\vol , val.linlin(0, 0.05, 0, 0.9 ),
			\cutoff, val.linlin(0.1, 1, 80, 300 ),
			\bwr, val.linlin(0, 1, 0.1, 1.7 ),
			\speedNoise, val.linlin(0, 1, 5, 30 )

			/*
			\cutoff, ((time_elpsd * 5) +80).clip2(300),

			\dur , 0.1,
			\envelope_sel , rrand(0, 1),
			\attack , 0.01, \decay_time , 0.1,
			\curve , -16,
			\mulNoise , 0.5,
			\bwr , (2.0 - (time_elpsd * 0.1).clip2(1.7) ),
			\which_noise , [0, 1,2].wchoose([0.2,0.4, 0.4]),
			\speedNoise, rrand(5, 30)
			*/
		);

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			time_elpsd;
			if(time_elpsd > 1, {
			});
		}, {
		});

	}
	{ which == 2 } {
		var time_elpsd;

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			time_elpsd;
			if(time_elpsd > 1, {
				~cnoise.set(\cutoff, ((time_elpsd * 5) +500).clip2(2000), \vol , ((time_elpsd * 0.01) + 0.01).clip2(0.9), \dur , 0.1, \envelope_sel , rrand(0, 1), \attack , 0.01, \decay_time , 0.1, \curve , -16, \mulNoise , 0.5, \bwr , (2.0 - (time_elpsd * 0.1).clip2(1.7) ), \which_noise , [0, 1,2].wchoose([0.2,0.4, 0.4]), \speedNoise, rrand(5, 30));
			});
		}, {
			~cnoise.set(\vol, 0);
		});
	}
	{ which == 3 } {
		var time_elpsd;

		Ndef(\softSin).set(\which, 1);
		// close session, a lot happens in the low range (0-0.3), it should change more the sound
		Ndef(\softSin).set(\proximity, val.linlin(0.0, 0.4, 0.1, 1));

		// far session
		//	Ndef(\softSin).set(\proximity, val.linlin(0, 0.9, 0, 1));

		//		Ndef(\softSin).set(\proximity, val.explin(0.001, 0.8, 0, 1));
		Ndef(\softSin).set(\volume, val.linlin(0, 0.001, 0, 0.7));
		Ndef(\softSin).set(\root, ~freq_root);

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			time_elpsd;
			if(time_elpsd > 1, {
				Ndef(\softSin).set(\lfoRate, 1+ (time_elpsd * 0.1).round(0.1).clip2(30), \lfoAmt, (time_elpsd * 0.01).clip2(0.5));
				Ndef(\softSin).set(\volume, 1.0);

			});
		}, {
			Ndef(\softSin).set(\lfoRate, 0.1, \lfoAmt, 0);
		});

	}
	{ which == 4 } {
		var time_elpsd;

		Ndef(\softSin).set(\which, 0);

		// close session, a lot happens in the low range (0-0.3), it should change more the sound
		Ndef(\softSin).set(\proximity, val.linlin(0.0, 0.4, 0, 1));

		// far session
		//	Ndef(\softSin).set(\proximity, val.linlin(0, 0.9, 0, 1));

		//		Ndef(\softSin).set(\proximity, val.explin(0.001, 0.8, 0, 1));
		Ndef(\softSin).set(\volume, val.linlin(0, 0.05, 0, 0.6));
		Ndef(\softSin).set(\root, ~freq_root);

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			time_elpsd;
			if(time_elpsd > 1, {
				Ndef(\softSin).set(\lfoRate, 1+ (time_elpsd * 0.1).round(0.1).clip2(30), \lfoAmt, (time_elpsd * 0.01).clip2(0.5));
				Ndef(\softSin).set(\volume, 1.0);

			});
		}, {
			Ndef(\softSin).set(\lfoRate, 0.1, \lfoAmt, 0);
		});

	}
	{ which == 5 } {
		var time_elpsd;

		~gran.set(\bufnum, ~rieko2);
		~gran.set(\volume, val.linlin(0, 0.01, 0, 0.7) + val.linlin(0.1, 1.0, 0, 1.0));
		//	~gran.set(\bufnum, ~rieko1);
		// ~rieko1,~rieko3

		// it must happen more between 0.2 and 0.4

		~gran.set(\trigRateR, val.linexp(0.05, 0.5, 2, 10));
		//~gran.set(\rndTrigRate, val.linlin(0.1, 1, 0, 2));
		//~gran.set(\amtRnd,  val.linlin(0.3, 0.7, 0.01, 0.3));

		//		~gran.set(\amVol, val.linlin(0.6, 1.0, 0.1, 0.5), \amFreq, val.linlin(0, 1, 200, 5000) , \dur, val.linlin(0.4, 1, 0.1, 0.5), \amp, val.linlin(0.01, 0.5, 0.5, 0.7) );

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			time_elpsd;
			if(time_elpsd > 1, {
				~gran.set(\amVol, ((time_elpsd * 0.035)).clip2(0.6), \amFreq, ((time_elpsd * 10) + 100).clip2(5000) , \dur, ((time_elpsd * 0.01) + 0.04).clip2(1), \amp, val.linlin(0.01, 0.5, 0.5, 0.7) );
			});
		}, {
			~gran.set(\amVol, 0, \amFreq, 100 , \dur, 0.05, \amp, 0.5 );
		});
	}
	{ which == 6} {
		//~fw.set(\volume, val.linlin(0, 0.05, 0, 1) );
		Ndef(\shepT).set(\volume, val.linlin(0, 0.05, 0, 1) );
		Ndef(\shepT).set(\proximity, val );

	}
	{ which == 7} {

		~glitch.set(
			\master_volume, val.linlin(0, 0.01, 0, 0.5),
			\modAmp1, val.linlin(0.01, 1, 1, 5),
			\modAmp2, 10,//,val.linlin(0.01, 1, 15, 19),
			\modAmp3, 15 + ~random_mod,
			\modF, 0.5,
			\gpos, 0.25
		);


	}
	{ which == 8} {
		var time_elpsd;
		~gran.set(\bufnum, ~clara1);

		~gran.set(\volume, val.linlin(0, 0.01, 0, 0.4));
		//	~gran.set(\bufnum, ~rieko1);
		// ~rieko1,~rieko3

		// it must happen more between 0.2 and 0.4

		~gran.set(\trigRateR, val.linlin(0.05, 0.5, 3, 10));
		//~gran.set(\rndTrigRate, val.linlin(0.1, 1, 0, 2));
		~gran.set(\amtRnd,  val.linlin(0.1, 0.7, 0.01, 0.3));

		//		~gran.set(\amVol, val.linlin(0.6, 1.0, 0.1, 0.5), \amFreq, val.linlin(0, 1, 200, 5000) , \dur, val.linlin(0.4, 1, 0.1, 0.5), \amp, val.linlin(0.01, 0.5, 0.5, 0.7) );

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			time_elpsd;
			if(time_elpsd > 1, {
				~gran.set(\volume, 0.6);

				~gran.set(\amVol, ((time_elpsd * 0.035)).clip2(0.6), \amFreq, ((time_elpsd * 10) + 100).clip2(5000) , \dur, ((time_elpsd * 0.01) + 0.01).clip2(1), \amp, val.linlin(0.01, 0.5, 0.5, 0.7) );
			});
		}, {
			~gran.set(\amVol, 0, \amFreq, 100 , \dur, 0.01, \amp, 0.5 );
		});

		/*
		if(time_elpsd > 3, {


		~glitch.set(
		\master_volume, val.linlin(0.01, 1, 0.01, 0.5),
		\modAmp1, val.linlin(0.01, 1, 0.01, 0.5),
		\modAmp2, ((time_elpsd * 0.005) + 1).clip2(10).postln,
		\modAmp3, 15,
		\gpos, rrand(-0.25, 0.25)
		);
		});

		*/


		// (time_elpsd.reciprocal * 1 * 25000).postln.clip2(5000).postln

		//"touched--".postln;



	}
	{ which == 9} {
		var env, wave;
		if(val > threshold, {
			~granbuf.set(\bufnum, ~buffers[0]);
			~granbuf.set(\volume, 0.5);
			~granbuf.set(\trigRate, 10);
			~granbuf.set(\amtRnd, 0.01);
			~granbuf.set(\dur, 0.06);
			~granbuf.set(\rndTrigRate, 3);
			~granbuf.set(\rate, rrand(0.95, 1.05));

			//env = Env([0, rrand(0.5, 1).postln, 0], [rrand(0.5,1.5), rrand(0.01, 0.5)], [8, -16]);
			//wave = Buffer.sendCollection(s, env.discretize, 1);
			~granbuf.set(\envbuf, -1);
		}, {
			~granbuf.set(\trigRate, 1);
			~granbuf.set(\amtRnd, 0.001);
			~granbuf.set(\dur, 1);
			~granbuf.set(\rndTrigRate, 1);
			~granbuf.set(\rate, 1);


		});

	}
	{ which == 10} {
		var time_elpsd;

		Ndef(\drone).set(\vol, val.linlin(0, 0.05, 0, 1) );
		Ndef(\drone).set(\freq_mul,  val.linlin(0.2, 1, 0.5, 0.8) );

		//Ndef(\drone).set(\lpf_freq, ((time_elpsd * 1) + 1000).postln);

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			time_elpsd;
			//		Ndef(\drone).set(\vol, 0.25);
			//		Ndef(\drone).set(\dev, time_elpsd * 0.05);
			if(time_elpsd > 3, {
				Ndef(\drone).set(\freq_mul, ( 0.7 + (time_elpsd * 0.005)).clip2(2.0));

				Ndef(\drone).set(\lpf_freq, ((time_elpsd * 1) + 1000));
			});

		});

	}
	{ which == 11} {
		var time_elpsd;
		//val.postln;
		val = val.explin(0.0001, 1, 0, 0.9);
		Ndef(\crazy_pad).set(\volume, val.linlin(0, 0.01, 0, 0.3));
		Ndef(\crazy_pad).set(\mulNoiseFreq, val.linlin(0.1, 1, 0.5, 20));
		Ndef(\crazy_pad).set(\freqMul, val.linexp(0.5, 1, 0.05, 0.5));
		Ndef(\crazy_pad).set(\rq_mod, val.linexp(0.5, 1, 1, 0.1) );

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			if(time_elpsd > 1, {
				Ndef(\crazy_pad).set(\mulNoiseFreq2, ((time_elpsd * 0.5) +1).clip2(30.0));

			});
		});


	}
	{ which == 12} {
		var time_elpsd;

		Ndef(\blowing).set(\proximity, val);

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			if(time_elpsd > 3, {
				Ndef(\blowing).set(\touched, (time_elpsd * 1).clip2(100));
			});
		}, {
			Ndef(\blowing).set(\touched, 1);

		});



	}
	{ which == 13} {
		var time_elpsd;
		~gran.set(\volume, 0.5);
		~gran.set(\bufnum, ~rieko2);

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;

			~gran.set(\trigRateR, 10);
			~gran.set(\amtRnd, 0.01);
			~gran.set(\dur, 0.2);
			~gran.set(\rndTrigRate, 5);
			~gran.set(\volume, rrand(0.4, 0.9));
			if(time_elpsd > 3, {
				~gran.set(\amVol, ((time_elpsd * 0.01) +0.2).clip2(0.9), \amFreq, (time_elpsd * 0.1 * 200).clip2(5000), \amtRnd, (time_elpsd * 0.001).clip2(0.8), \dur, 0.1 + (time_elpsd * 0.005).clip2(0.5), \volume, 0.4+(time_elpsd * 0.01).clip2(0.4) );
				//		~glitch.set(\master_volume, (time_elpsd * 0.01).clip2(1.0), \modAmp1, (~random_mod + (time_elpsd / 5).asInt).postln, \modAmp2, ((time_elpsd * 0.001) + 1).clip2(10), \modAmp3, 15);


			});

			// (time_elpsd.reciprocal * 1 * 25000).postln.clip2(5000).postln

			//"touched--".postln;

		}, {
			~glitch.set(\master_volume, 0);
			~gran.set(\trigRateR, 1);
			~gran.set(\amVol, 0, \amFreq, 80);

			~gran.set(\trigRate, -1.5);
			~gran.set(\amtRnd, 0.03);
			~gran.set(\dur, 1.5);
			~gran.set(\rndTrigRate, 1);
			~gran.set(\volume, rrand(0.3, 0.6));
			~gran.set(\amVol, 0);
			//"untouched--".postln;

		});
	}
	{ which == 14} {
		var time_elpsd;

		Ndef(\mod_bubble).set(\volume, val.linlin(0.001, 0.01, 0.0, 0.15) + val.linlin(0.01, 1.0, 0.0, 0.25) );

		Ndef(\mod_bubble).set(\proximity, val);

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			if(time_elpsd > 1, {
				Ndef(\mod_bubble).set(\freq_mod, ((time_elpsd * 0.1)  ).clip2(20.0));
				//			Ndef(\mod_bubble).set(\volume, ((time_elpsd * 0.05)  + 0.5 ).clip2(1.5));
				Ndef(\mod_bubble).set(\decaytime, ((time_elpsd * 0.05)  ).clip2(5));
				Ndef(\mod_bubble).set(\delaytime, ((time_elpsd * 0.01)  ).clip2(0.29));

			}, {
				Ndef(\mod_bubble).set(\freq_mod, 0);
				Ndef(\mod_bubble).set(\decaytime, 0);
				Ndef(\mod_bubble).set(\delaytime, 0);
			});
		});


	}
	{ which == 15} {
		val;

		Ndef(\trigger_sin).set(\source, val);
	}
	{ which == 16} {
		var time_elpsd;

		Ndef(\pulse).set(\volume, val.linlin(0, 0.1, 0, 0.3) );

		Ndef(\pulse).set(\freq_mod, val.linlin(0, 1, 0, 10) );
		Ndef(\pulse).set(\delayTime, val.linlin(0, 1, 0.25, 0.01) );

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			if(time_elpsd > 1, {
				//			Ndef(\pulse).set(\delayTime, ((time_elpsd * 0.01) +0.03  ).clip2(1.0));
				Ndef(\pulse).set(\freq_dev, ((time_elpsd * 0.3) +0.01  ).clip2(10.0));

			}, {
				Ndef(\pulse).set(\delayTime, 0.03);
				Ndef(\pulse).set(\freq_dev, 0.01);			});
		});




	}
	{ which == 17} {

		Ndef(\test_touch).set(\vol, val.linlin(0, 0.05, 0, 0.5));

		Ndef(\test_touch).set(\freq, val.linexp(0.05, 1, 100, 1000));
	}
	{ which == 18} {

		var time_elpsd;
		~natteredMoon.set(\pitchBend, val.linlin(0, 1.0, 0, 0.2), \volume, val.linlin(0.01, 0.1, -0.001, 0.05) + val.linexp(0.1, 1.0, 0.001, 0.4), \mod, val.linlin(0, 1.0, 0, 0.5));
		~natteredMoon.set(\mDist, 1);


		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			if(time_elpsd > 1, {
				~natteredMoon.set(\mDist,  ((time_elpsd * 0.01) + 0.9 ).clip2(2.0));
				~natteredMoon.set(\dronelvl, ((time_elpsd * 0.05) ).clip2(1.0));
			}, {
				~natteredMoon.set(\mDist,  0);
				~natteredMoon.set(\dronelvl, 0);

			});
		});


	}
	{ which == 19} {
		var time_elpsd;

		Ndef(\vinylCrackling).set(\volume, val.linlin(0, 0.1, 0, 0.15) + val.linlin(0.1, 1.0, 0, 0.1));
		Ndef(\vinylCrackling).set(\proximity, val.linlin(0.1, 1.0, 0.0, 0.8) );

		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			if(time_elpsd > 1, {
				Ndef(\vinylCrackling).set(\which,  ((time_elpsd * 0.1) ).clip2(1.0));
				Ndef(\vinylCrackling).set(\combSpeed, ((time_elpsd  * 0.01) ).clip2(30.0));
			});
		});

		if(val < threshold, {
			Ndef(\vinylCrackling).set(\which,  0);
			Ndef(\vinylCrackling).set(\combSpeed, 0.1);

		});


	}
	{ which == 20} {
		Ndef(\pad_wu).set(\vol, val.linlin(0, 0.1, 0, 0.25));

		Ndef(\pad_wu).set(\source, val.linexp(0, 1, 0.0001, 1));
	}
	{ which == 21} {
		Ndef(\pad_wi).set(\vol, val.linlin(0, 0.02, 0, 1.0));

		Ndef(\pad_wi).set(\source, val.explin(0.00001, 1, 0, 1));

	}
	{ which == 22} {
		Ndef(\padnoise).set(\vol, val.linlin(0, 0.1, 0, 0.7));

		Ndef(\padnoise).set(\value, val.linlin(0, 1, 0, 0.2));
	}
	{ which == 23} {
		var time_elpsd;

		Ndef(\twinP).set(\proximity, val);


		if(val > threshold, {
			time_elpsd = Main.elapsedTime.asInt - now;
			if(time_elpsd > 1, {
				Ndef(\twinP).set(\touched, (time_elpsd * 2.5).clip2(50));
			});
		}, {
				Ndef(\twinP).set(\touched, 1);
			});

	}
	{ which == 24} {

	}
	{ which == 25} {

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


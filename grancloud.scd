
		a = GranCloud.preset(s, "sine_grain"); // wait until server is fully booted
		a.play;
		a.center[\freq] = 220;  // change freq
		a.putEnv(\freq, Env.new([ 50, 1100, 200, 660, 300 ], [ 4, 1, 0.5, 5 ], 'exponential'));
		a.center[\freq] = Pseq(Array.fill(20, { 50.exprand(1000) }), inf).asStream;
		a.center[\rate] = 0.5;  a.center[\dur] = 1.0;     // slow down the grains
		a.center[\dur] = 0.02; a.center[\rate] = 0.005;   // speed up the grains
		a.dev[\rate] = 0.01;
		a.dev[\freq] = 500;
		a.dev[\pan] = 2.0;
		a.dev[\pan] = 0.2;
		a.center[\pan] = -0.5;
		a.center[\pan] = Env.new([ -0.8, 0.8, 0 ], [ 4, 2 ]); a.reset(0); // reset playTime to 0
		a.stop;


		a = GranCloud.preset(s, "glisson");
		a.play;
		a.center[\rate] = 0.5;  a.center[\dur] = 0.5;
		a.center[\startFreq] = 50;
		a.center[\rate] = 0.05;  a.center[\dur] = 0.1;
		a.center[\startFreq] = 3000; a.center[\endFreq] = 30;
		a.center[\startFreq] = 200;
		a.center[\endFreq] = 200;
		a.dev[\startFreq] = 0;
		a.dev[\endFreq] = 0;
		a.dev[\startFreq] = 150;
		a.center[\rate] = 0.02;
		a.center[\endFreq] = 400;
		a.dev[\startFreq] = 50;
		a.stop;


		b = Buffer.read(s, Platform.resourceDir +/+"sounds/a11wlk01-44_1.aiff")
;
b = Buffer.read(s,"/Users/marcello/Music/Samples/musicradar-noise-hiss-crackle-samples/White_Noise_Raw/Modular_Raw_d.wav");
a.play
		a = GranCloud.preset(s, "buf_grain", b.bufnum);
		a.center[\bufStartPos] = Env([ 0, 1, 0, 1, 0 ], [ 3, 0, 1, 6 ]);
		a.loop[\bufStartPos] = [ 0, 10, inf ];
		a.play;
		a.center[\bufRate] = 2.0;
		a.center[\bufRate] = 0.5;
		a.putEnv(\bufRate, Env([ 1, 0.15, 3, 0.75 ], [ 3, 4, 3 ]));
		a.dev[\bufRate] = 1.0;

			
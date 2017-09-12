/*
1. einzelne rauschen: checken, dass ein gutes rauchen immer kommt

2. pad nice/awful
todo:
- pad piacevole che diventa spiacevole, magari con gauss?
- gendy?

3. kaputtes klavier, szene mit 2 teile:
- einzelne klänge, sound = 5
- entwicklung, kontinuierliche klang, granular, langsam und schnell => umschaltung bauen!
- kontinuierlicher klang ist schöne klavier taste, wenn man angefasst wird, wieder chaotisch (granular)
- gute stelle von rieko1 aussuchen

4. text von merleau ponty

5. granular: if the touch stays, increase with the touched time the trigrate and decrease the dur. maybe add also some AM and other params?

6. klank touch? in tests

7. gui: add slider for lower and upper treshold of the signal

*/


(
var triggered =0, touch_thres = 0.4, debug =0, time, now, prox = SensorDataExt.new, val,  trig;
time = Main.elapsedTime.asInt;
now = (time)-0.1;
~lastVal =0;
~sound1 = 0;
~sound2 = 0;
~random_mod = 0;

OSCdef(\touch, {|msg, time|
	msg;
	~raw = msg[1];//.explin(0.01, 1.0, 0.001, 1);

	//x.set(\val, e);
	/*
	~fw.set(\scale_tones, e.linlin(0,1, 1, 200));
	~fw.set(\amp, e.linlin(0,0.2, 0.0, 0.2));
*/
	prox.addValue( ~raw );
	prox.stlen_( 10 );
	prox.ltlen_( 30 );

	//Ndef(\noise).set(\val, e);
	~mas = prox.shortSMA;

	~expMa = prox.expMA.linlin(~lower_thres, ~upper_thres, 0, 1);//.explin(0.04, 0.5, 0.001, 1);

	~mal = prox.shortStdDev;//.linlin(0.1, 0.2, 0, 1);


	if(debug >0, {
	("~raw: "++~raw).postln;
	("~mas: "++~mas).postln;
	("~expMa: "++~expMa).postln;

	("~mal: "++~mal).postln;
												"-end-".postln;

	});

		//lowPassFreq = MouseX.kr(100, 8000);lowPassQ = MouseX.kr(2, 1);





	if((~mal > touch_thres) && (triggered == 0),
		{

			if(debug ==2,
				{
					("~raw: "++~raw).postln;
					("~mas: "++~mas).postln;
					("~expMa: "++~expMa).postln;
					("~mal: "++~mal).postln;
										"-end-".postln;


	});



			//~fw.set(\amp2, 0);

			//"touch".postln;
			triggered = triggered + 1;
	});
		if((~mal > touch_thres) && (triggered == 1), {

	});
	if((~mal < touch_thres) && (triggered > 1), {
		triggered = 0;
		//	"untouch".postln;

//		~fw.set(\amp2, 1);

	});

				//	("~expMa: "++~expMa).postln;
	//("~mal: "++~mal).postln;

		case
		{ ~expMa < touch_thres } { trig = 0 } //
		{ ~expMa < 1.0 } { trig = 1 };


	if(trig > ~lastVal, {
		//"touched".postln;

/*
		// pad
				Ndef(\pad).set(\volume, 0);
// granulator
		~gran.set(\pos, rrand(0.0, 0.99));
		~gran.set(\trigRate, ~expMa.linlin(touch_thres, 1, 1, 10));
		~gran.set(\rate, ~expMa.linlin(touch_thres, 1, 1, 1.5));
		~gran.set(\rndTrigRate, rrand(0.5, 15.0));
		~gran.set(\dur, ~expMa.linlin(touch_thres, 1, 0.2, 1));
		// wavPlayer, with noise sounds
Synth(\wavPlayer,  [ \bufnum, ~noise, \speed , rrand(0.5, 1.5), \pos, rrand(0.0, 0.9).postln, \dur , 0.1, \envelope_sel , 1, \attack , 0.01, \cutoff, rrand(100, 400).postln, \decay_time , 0.3, \curve, -4]);
		*/
		// noisePlayer, group the type of sounds
						now = (time.asInt).postln;

		~data_sel_trigger.value(~expMa, ~sound1, touch_thres );
		//~data_sel_trigger.value(~expMa, ~sound2, touch_thres );

		//rndTrigRate = 0, speedRndTrigRate = 5, speedRndRate
	});

	if(trig < ~lastVal, {
				"untouch".postln;
				~data_sel_untrigger.value(~expMa, ~sound1, touch_thres );

	});
		~lastVal = trig; //update
		~data_sel_cont.value(~expMa, ~sound1, touch_thres, now );
		//~data_sel_cont.value(~expMa, ~sound2, touch_thres, now );

	//x.set(\amp, ~val.linlin(0, 0.2, 0, 1));
		//x.set(\cutoffFreq, ~val.linlin(0.2, 0.7, 1000, 10000));
	//~val = LPF.kr(e);
	}, "/closer/sender1/channe2",
nil,
	9677);
)

/*


~gran.set(\rate, 0.1);

~gran.set(\rndTrigRate, 2);
~gran.set(\trigRate, 1);
~gran.set(\amtRnd, 0.05);
p = NetAddr("127.0.0.1", 57120); // loopback

p.sendMsg("/touch", 0.7);
p.sendMsg("/touch", 0.9);

		Synth(\wavPlayer, [\bufnum, ~martin, \speed, [1/16,1/8,1/4,1/2,0.75, 1].choose.postln, \pos, rrand(0.0, 0.95).postln, \vol, 1]);
		Ndef(\pad).set(\master_vol, 0.5);

			Ndef(\pad).set(\volume, 0.5);
*/
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


~seq_sinTrig.next
f = Env([0.0, 1.0], 1.0, 0);e = Env([0, 0.5, 1.0], [0.5, 0.5], [-2, 2]);e[0.2];
e.plot; f.plot;
Env([0, 0.4, 1.0], [0.5, 0.5], [-2, 6]).plot
// Env([0, 0.3, 0.6, 1], [0.1, 0.1, 0.1], [2, 2, 2]).plot
*/
(
var triggered =0,  debug =0, time, now = 0, prox = SensorDataExt.new, val,  trig = 0, scale;

~lastVal =0;
~sound1 = 0;
~sound2 = 0;
~random_mod = 0;
~freq_root = 53;
scale = [86, 82, 79, 73, 72, 70, 66, 60, 59,58,55, 53 ].reverse;
//rand = .asStream;
~seq_sinTrig = Pseq([Pxrand(scale,3) ++ Pstutter(Prand([1, 2, 3], 1), Prand(scale, 1))], inf).asStream;

OSCdef(\touch, {|msg, time|
	var env, debug = 0;
	//env = ControlSpec(0, 1, \lin, 0.001);
	//env = Env([0, 0.3, 0.6, 1], [0.1, 0.1, 0.1], [2, 2, 2]);
	env = Env([0, 0.4, 1.0], [0.5, 0.5], [-2, 6]);
	//msg.postln;

	//~raw = env.map(msg[3]);
	//~raw = env[msg[3]];
	~raw = msg[3];

	//~raw= msg[3].linlin(0, 1, 0, 1);

	//~amp.postln;
	prox.addValue( ~raw );

	prox.stlen_( 5 );

	~sma = prox.shortSMA;

	~expMa = prox.expMA.explin(~lower_thres, ~upper_thres, 0, 1);//.explin(0.04, 0.5, 0.001, 1);


	if(debug >0, {
		("~raw: "++~raw).postln;
		("~mas: "++~mas).postln;
		("~expMa: "++~expMa).postln;

		("~mal: "++~mal).postln;
		"-end-".postln;

	});


	case
	{ ~expMa < ~touch_thres } { trig = 0 } //
	{ ~expMa < 1.0 } { trig = 1 };


	if(trig > ~lastVal, {
		time = Main.elapsedTime.asInt;
		now = (time)-0.1;
		"touched".postln;
		~data_sel_trigger.value(~expMa, ~sound1, ~touch_thres );

	});

	if(trig < ~lastVal, {
		"untouch".postln;
		~data_sel_untrigger.value(~expMa, ~sound1, ~touch_thres );

	});
	~lastVal = trig; //update
	~data_sel_cont.value(~expMa, ~sound1, ~touch_thres, now );

}, "/tr");
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
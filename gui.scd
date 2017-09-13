

(

var w, amp, freq, csAmp, csFreq, sender, sound1, sound2, upperLowerThres, touching, untouch, touch_routine;
sender = NetAddr("127.0.0.1", 57120);
sender.sendMsg("/start", 1);
w=FlowView.new(windowTitle:"Send OSC", bounds:Rect(400,500,400, 500));

csFreq=EZSlider(w, label:"touch ", controlSpec:[0.0, 1.0, \lin, 0.01, 0], action:{|mv| Ndef(\receive).set(\touch_slider,  mv.value); }, initVal:0);

upperLowerThres = EZRanger(w, 400@16, "sig thres", [0.01, 2.0, \lin, 0.01, 0.01], {|v| ~lower_thres = v.value[0]; ~upper_thres = v.value[1];}, [~lower_thres, ~upper_thres ], unitWidth:30);

sound1 = EZListView.new(w,
	300@250,
	"Sample1:",
	[
		"sound 0, no sound" ->{  ~sound1 = 0; },
		"sound 1, sinus  hi2low" ->{  ~sound1 = 4; },
		"sound 1b, sinus  low2hi" ->{  ~sound1 = 3; },

		"sound 2, pulse 16" ->{  ~sound1 = 16; },
		"sound 3, bubble 14" ->{  ~sound1 = 14; },
		"sound 4, blowing 12" ->{  ~sound1 = 12; },
		"sound 5, twinP 23" ->{  ~sound1 = 23; },

		/*		"sound 5, crackle 19" ->{  ~sound1 = 19; },

		"sound 2, granular 8 " ->{  ~sound1 = 8; },
		"sound 3, shepard 6" ->{  ~sound1 = 6; },
		"sound 2, natteredMoon 18" ->{  ~sound1 = 18; },


		"sound 17, touchme - donttouchme" ->{  ~sound1 = 17; },
		"sound 8, gran clara1" ->{  ~sound1 = 8; },
		"sound 0, no sound" ->{  ~sound2 = 0; },
		"sound 5, piano, inside" ->{  ~sound1 = 5; },
		*/




	],
	// globalAction: { |a| ("this is a global action of "++a.asString ).postln },
	initVal: 0,  initAction: true, labelWidth: 100, labelHeight: 30, layout: \vert,gap: 2@2
);

csFreq = Button(w, Rect(90, 20, 200, 30))
.states_([
	["Signal", Color.black, Color.red],
	["Mouse Test", Color.black, Color.green],
	["Slider", Color.black, Color.blue]

])
.action_({ arg butt;
	x = case
	{ butt.value == 0} { 	~receive.set(\test, 0);
	}
	{ butt.value == 1} { 	~receive.set(\test, 1);
	}
	{ butt.value == 2} { 	~receive.set(\test, 2);
	};
});

/*
sound2 = EZListView.new(w,
300@250,
"Sample2:",
[
"sound 0, no sound" ->{  ~sound2 = 0; },
"sound 1, noise, low" ->{  ~sound2 = 1; },
"sound 2, noise, mid" ->{  ~sound2 = 2; },
"sound 3, noise, hi" ->{  ~sound2 = 3; },
"sound 4, noise, crackle" ->{  ~sound2 = 4; },
"sound 5, piano, inside" ->{  ~sound2 = 5; },
"sound 6, piano, keys" ->{  ~sound2 = 6; },
"sound 7, piano, plucking" ->{  ~sound2 = 7; },
"sound 8, gran clara1" ->{  ~sound2 = 8; },
"sound 9, granbuf" ->{  ~sound2 = 9; },
"sound 10, drone" ->{  ~sound2 = 10; },
"sound 11, pad" ->{  ~sound2 = 11; },
"sound 12, space keys" ->{  ~sound2 = 12; },
"sound 13, gran, piano keys" ->{  ~sound2 = 13; },
"sound 14, comb tapping" ->{  ~sound2 = 14; },
"sound 15, comb tapping" ->{  ~sound2 = 15; },
"sound 16, comb tapping" ->{  ~sound2 = 16; },
"sound 17, comb tapping" ->{  ~sound2 = 17; },
"sound 18, comb tapping" ->{  ~sound2 = 18; },

],
// globalAction: { |a| ("this is a global action of "++a.asString ).postln },
initVal: 0,  initAction: true, labelWidth: 100, labelHeight: 30, layout: \vert,gap: 2@2
);

*/
touching = Task({
	inf.do({ arg i;
		sender.sendMsg("/closer/sender1/channe2", rrand(0.8, 0.9));
		0.15.wait
	});
});

untouch = Task({
	3.do({
		sender.sendMsg("/closer/sender1/channe2", 0.3);
		sender.sendMsg("/closer/sender1/channe2", 0.1);
		0.1.wait;

	})
});

w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;
	var x;
	keycode.postln;

	x = case
	{keycode == 38 } {
		6.do({
			sender.sendMsg("/closer/sender1/channe2", 0.99);
		});
		untouch.start;
		untouch.stop;
		untouch.reset;
	}
	{keycode == 40 } {
		touching.start;
	}
	{keycode == 37 } {
		touching.stop;
		touching.reset;

		untouch.start;
		untouch.reset;
	};
};

w.view.keyUpAction = { arg view, char, modifiers, unicode, keycode;
	if(keycode == 38, {
		3.do({

			sender.sendMsg("/closer/sender1/channe2", 0.3);
			sender.sendMsg("/closer/sender1/channe2", 0.1);
		});
	});
};
w.front;

)
/*
(
w = Window.new("The Four Noble Truths");

t = ToggleButton(w,"touch",{

"touch".postln;

},false);


w.front;
)
*/
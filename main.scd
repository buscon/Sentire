("".resolveRelative++"data_selection_continuous.scd").openOS;
("".resolveRelative++"ndefs.scd").openOS;
("".resolveRelative++"synths_toLoad.scd").openOS;
	("".resolveRelative++"data_receive.scd").openOS;
("".resolveRelative++"gui.scd").openOS;
~lower_thres = 0.05
/*
preamp
1.
2. 10 preamp, sig thres to 0.06
*/
Ndef(\pulse).set(\volume, 0.5)

Ndef(\pulse).get(\volume)
(
t = Task({
~lower_thres = 0.03;
~upper_thres = 1.0;
~touch_thres = 0.95;
~touch_slider = 0;
("".resolveRelative++"data_selection_continuous.scd").load;
("".resolveRelative++"data_selection_trigger.scd").load;
("".resolveRelative++"data_selection_untrigger.scd").load;
1.wait;
("".resolveRelative++"synths_toLoad.scd").load;
	2.wait;
("".resolveRelative++"ndefs.scd").load;

1.wait;

	("".resolveRelative++"data_receive.scd").load;
 	1.wait;

	Ndef(\receive).set(\test, 0);
1.wait;

("".resolveRelative++"osc.scd").load;
1.wait;
("".resolveRelative++"gui.scd").load;
1.wait;

("".resolveRelative++"plotter.scd").load;
1.wait;

ProxyChain.add(
//            \freeVerb,  \filter -> { |in| FreeVerb.ar(in, 0.5) },
            \GVerb,  \filter -> { |in| GVerb.ar(in, 100) },

    \limiter,  \filter -> { |in, l_level=1.0| Limiter.ar(in, l_level) },
);

m = MasterFX.new(server: s,
    numChannels: 8,
    slotNames: [ \GVerb, \limiter ],
		busIndex: 0
);

Spec.add(\l_level, [0.1, 1.0, \exp]);
Spec.add(\l_level, [0.1, 1.0, \exp]);

m.gui;
	~receive.set(\test, 0);
	"=============DONE=============".postln;
},AppClock).start;
)

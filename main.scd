


/*
1. 1. hi2low
2. 3. bubble joern
3. 4. blowing delph
4. 3. pulse Dasha
5. 6. twinP Fan
6. 2. low2hi Quan

comments:
less interaction with hands
find other trajectories of movement?
stay longer in touch

preamp
1. 28 preamp, sig thres 0.030 -  18 for touching
2. 10 preamp, sig thres to 0.8

0.052 threshold

*/
Quarks.gui
Ndef(\twinP).set(\root_freq, 1);
Ndef(\pulse).set(\volume2, 1.0)

Ndef(\pulse).get(\volume)

("".resolveRelative++"data_selection_untrigger.scd").openOS;
("".resolveRelative++"data_selection_trigger.scd").openOS;
("".resolveRelative++"ndefs.scd").openOS;
("".resolveRelative++"data_selection_untrigger.scd").openOS;
("".resolveRelative++"synths_toLoad.scd").openOS;

Ndef(\pulse)
MasterEQ.new
		Ndef(\pulse).set(\volume2, 0);
		~freq = exprand(100, 1000).postln;
		Ndef(\pulse).set(\root_freq, ~freq );

(
t = Task({
	~output = 0;
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
		busIndex: ~output
);


Spec.add(\l_level, [0.1, 1.0, \exp]);
Spec.add(\l_level, [0.1, 1.0, \exp]);

m.gui;
s.meter;
	s.freqscope;
	~receive.set(\test, 0);
	"=============DONE=============".postln;
},AppClock).start;
)

		Ndef(\pulse).set(\root_freq, 200 );

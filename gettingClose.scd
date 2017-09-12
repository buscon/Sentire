p.clock = TempoClock.default;

( ~arhu = Ndef(\arhu, {|freq = 200 , dur = 1| Splay.ar( LFSaw.ar(XLine.kr([1, 4, 2]*freq, [0.2, 0.4, 0.6]*freq, 0.5*dur)) * EnvGen.kr(Env.perc(0.001, dur-0.0001), doneAction: 2) ) }).play; );

~arhu.play;
~arhu.set(\vol, 0.3);

( ~loco = Ndef(\loco, { var modFreq = MouseX.kr(1, 20); SinOsc.ar(Saw.ar(modFreq).lag(0.01).exprange(10, 1000), 0, 0.1)!2 }).play; );

~loco.set('modFreq', 20.312);
~gne = Ndef(\gne, {SinOsc.ar(~lfmod, 0, 0.1)!2}).play;
~lfmod = 30;
~loco = Ndef(\loco,{});
~lfmod.set('fadeTime', 10);
~lfmod = 300;

 ~arhu.play;
~gne.play;
~loco.play;

Tdef(\player).clock = TempoClock.default; Tdef(\player, {loop{ ~arhu.spawn([\freq, exprand(500, 10000), \dur, exprand(1, 0.1)]); ([0.25, 0.1, 0.5]*0.2).choose.wait; }})
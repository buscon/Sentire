ChaosGen

ChaosGen.allSubclasses.do(_.postln)



// default initial params
{ GbmanL.ar(MouseX.kr(20, SampleRate.ir)) * 0.1 }.play(s);

// different initial params
{ GbmanL.ar(MouseX.kr(20, SampleRate.ir), -0.7, -2.7) * 0.1 }.play(s);

// wait for it...
{ GbmanL.ar(MouseX.kr(20, SampleRate.ir), 1.2, 2.0002) * 0.1 }.play(s);

// as a frequency control
{ SinOsc.ar(GbmanL.ar(40)*400+500)*0.4 }.play(s);
// randomly modulate params
(
{ FBSineC.ar(
    LFNoise2.kr(1, 1e4, 1e4),
    LFNoise2.kr(1, 32, 33),
    LFNoise2.kr(1, 0.5),
    LFNoise2.kr(1, 0.05, 1.05),
    LFNoise2.kr(1, 0.3, 0.3)
) * 0.2 }.play(s);
)

{ LorenzL.ar(MouseX.kr(20, SampleRate.ir)) * 0.3 }.play(s);

// randomly modulate params
(
{ LorenzL.ar(
    SampleRate.ir,
    LFNoise0.kr(1, 2, 10),
    LFNoise0.kr(1, 20, 38),
    LFNoise0.kr(1, 1.5, 2)
) * 0.2 }.play(s);
)
3e-3
{ SinOsc.ar(Lag.ar(LorenzL.ar(MouseX.kr(1, 200)),3e-3)*800+900)*0.4 }.play(s);
//ServerOptions.devices[0]; // this should be the soundcard
//s.options.device = ServerOptions.devices[0];
//s.boot;

~transmit = Ndef(\transmit, {
	var out = SinOsc.ar(SampleRate.ir/4);
	Out.ar(3, out * 0.3);
}).play;

/* test:
0 real signal
1 mouse input
2 slider input
*/
~receive = Ndef(\receive, {|test =0, touch_slider  = 0|
	var sig,filt,amp=0;
	sig = SoundIn.ar(0);
	filt = BLowPass4.ar(sig, SampleRate.ir/4, 0.004);
	amp = Amplitude.kr(filt, 0.01, 0.1, 1);
	amp = Select.kr(test, [amp , MouseX.kr(), touch_slider]);

	SendTrig.kr(Impulse.kr(SampleRate.ir/400), 0, amp);
}).play;

/*
//s.scope;
(
OSCdef(\touch, {|msg, time|
	msg[3].postln;
}, '/tr');
)

*/

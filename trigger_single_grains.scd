b = Buffer.read(s, "/Users/marcello/Music/Samples/SonarQuartett/string_test.aiff");
b = Buffer.readChannel(s, "/Users/marcello/Music/Samples/GranularSelection/11Marianne1_nosilence.wav", channels:[0]);
b= Buffer.readChannel(s,"/Users/marcello/Music/Samples/opera/0004 mkh40.wav", channels:[0]);
b
b.free
(


Ndef(\trigger_sample, {|bufnum = 0, source = 0, pos =0.8, bgate = 1, rate =1|
	var  trigUp, trigDown, aEnvUp, aEnvDown, aEnvNoise, fEnv, amp =0.2, ausgang, ausgangUp, ausgangDown;

	pos = MouseY.kr(0, BufFrames.kr(bufnum));
	source= MouseX.kr(0,1).round(0.001);//LFNoise0.ar(100);
	//source= LFNoise0.kr(10).abs.poll;
//	trig= Trig1.ar((source- Delay1.kr(source)).abs , 0.001); //0.001 is duration of trigger signal output. with .abs Trig1 triggers both when the input value increases and decreases. Without .abs it triggers only when the value increases. With .neg it triggers only when the value decreases.
	trigUp= Trig1.ar((source- Delay1.kr(source)) , 0.001);
	trigDown= Trig1.ar((source- Delay1.kr(source)).neg , 0.001);
	aEnvUp = EnvGen.ar(Env.perc(0.03, source.linlin(0,1, 0.1, 3.0)), gate: trigUp);
	aEnvDown = EnvGen.ar(Env.perc(0.03, source.linlin(0,1, 0.1, 3.0)), gate: trigDown);

	ausgang =   PlayBuf.ar(1, bufnum, 1, bgate, BufRateScale.kr(bufnum) * source.linlin(0,1, 0.1, 0.9),  loop:1) * 0.05;

	ausgangUp = aEnvUp *   PlayBuf.ar(1, bufnum, source.linlin(0,1, 1.0, 1.1), bgate, BufRateScale.kr(bufnum) * source.linlin(0,1, 0.1, 0.9),  loop:1);
	ausgangDown = aEnvDown *   PlayBuf.ar(1, bufnum, source.linlin(0,1, 0.9, 1.0), bgate, BufRateScale.kr(bufnum) * source.linlin(0,1, 0.1, 0.9),  loop:1);
	ausgang = ausgangDown + ausgangUp + ausgang;

	ausgang = GVerb.ar(ausgang * amp, 50, 1.5) * 3.5;
	ausgang = LeakDC.ar(ausgang);

	Out.ar(0, ausgang);


}).play;
)
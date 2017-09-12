	d = SWPlotterMonitor.new( {
    //data to plot
    [
    [ ~expMa], // view the two streams superimposed
    //[~~e - ~f], // view their differene
    //[(~e- ~f).sign] // view sign of difference
    ]},
    100, //nr of points to plot
    2, // channels
    0.2, // plot dtime
	2 // write every n data points
    ).start;

//d.stop

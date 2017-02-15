using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Greg;

class CoolWatchfaceView extends Ui.WatchFace {

	//integer values for colors
	var white = 16777215;
	var blue = 43775;
	var font = Gfx.FONT_NUMBER_THAI_HOT;
	var fontBatt = Gfx.FONT_SMALL;
	var clockTime;

    function initialize() {
        WatchFace.initialize();

    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    //Checks it the hour unit is empty because of the hour is less than 10
	function checkLessThan10(unit){
		
		var check = false;
		if(unit.equals("") || unit == null ){
			check = true;
		}
		return check;
	}	
	
	//get the date of the current moment
	function getDate(){
		var nowInfo = Greg.info(Time.now(), Time.FORMAT_MEDIUM);
		var nowString = Lang.format("$1$/$2$", [nowInfo.day, nowInfo.month]);
		return nowString;
	}
    //fill an array with the hour unit and the hour tens
    function getHours(){
    	var hours = new [2];
    	var timeString = Lang.format("$1$", [clockTime.hour]);
		hours[0] = timeString.substring(0,1);
		hours[1] = timeString.substring(1,2);
		return hours;
	}
	//fill an array with the minutes unit and the minutes tens
	function getMins(){
    	var mins = new [2];
    	var timeString = Lang.format("$1$", [clockTime.min.format("%02d")]);
		mins[0] = timeString.substring(0,1);
		mins[1] = timeString.substring(1,2);
		return mins;
	}

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
	    clockTime = Sys.getClockTime();
		
		var mins = getMins();
		var hours = getHours();
		
		var batteryLevel = Sys.getSystemStats();
		var batteryString = Lang.format("$1$%",[batteryLevel.battery.format("%01d")]);
		
		var textDim = dc.getTextDimensions(hours[0], font);
		
		var xNumber = textDim[0];
		var yNumber = textDim[1];
	    var x = dc.getWidth();
	    var y = dc.getHeight();
		
		//In case of 0-9 hours natively there will not be two digits
		//This part forces to show two digits
		if(checkLessThan10(hours[1])){
			hours[1] = hours[0];
			hours[0] = 0;
		}
		
	    var xLeft = (x/2 - xNumber)+y/8;
	    var xRigth = (x/2 + xNumber)-y/8;
	    
	    var yTop = (y/2 - yNumber/3)-y/2.7;
	    var yBottom = (y/2 + yNumber/3)-y/4.7; 
	   	
	    dc.setColor(Toybox.Graphics.COLOR_BLACK, Toybox.Graphics.COLOR_BLACK);
	    dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
	    
	    dc.setColor(white, Gfx.COLOR_BLACK);
	    dc.drawText(xLeft,yTop, font, hours[0], Gfx.TEXT_JUSTIFY_CENTER);
	    
	    dc.setColor(blue, Gfx.COLOR_BLACK);
	    dc.drawText(xRigth,yTop, font, hours[1], Gfx.TEXT_JUSTIFY_CENTER);
	    
	    dc.setColor(blue, Gfx.COLOR_BLACK);
	    dc.drawText(xLeft,yBottom, font,  mins[0], Gfx.TEXT_JUSTIFY_CENTER);
	    
	    dc.setColor(white, Gfx.COLOR_BLACK);
	    dc.drawText(xRigth,yBottom, font,  mins[1], Gfx.TEXT_JUSTIFY_CENTER);
	    
	    dc.setColor(white, Gfx.COLOR_BLACK);
	    dc.drawText(x/8,y/2, fontBatt, batteryString, Gfx.TEXT_JUSTIFY_CENTER);
	    
	    dc.setColor(white, Gfx.COLOR_BLACK);
	    dc.drawText(x - x/7,y/2, fontBatt, getDate(), Gfx.TEXT_JUSTIFY_CENTER);
        
    }
    


    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}

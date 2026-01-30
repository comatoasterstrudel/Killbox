package killbox.game.night.rooms.main.clock;

class ClockHand extends KbSprite
{
    var clock:Clock;
    
    public function new(clock:Clock, suffix:String):Void{
        super();
        
        this.clock = clock;
        
        createFromImage('assets/images/night/rooms/main/main_clock' + suffix + 'Hand.png');
    }
    
    public function updateHandPosition(val:Float):Void{
        var theAngle = 360 * val;
        
        var point = clock.clockSprite.getGraphicMidpoint().place_on_circumference(theAngle, width / 2);

		setPosition((point.x - width / 2) + Constants.ROOM_MAIN_CLOCKHANDOFFSET.x, (point.y - height / 2) + Constants.ROOM_MAIN_CLOCKHANDOFFSET.y);		
		angle = theAngle;
		
		point.put();
    }
}
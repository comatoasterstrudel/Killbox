package killbox.game.night.rooms.main.clock;

class Clock extends FlxSpriteGroup
{
    /**
     * the sprite for the actual clock, not hands
     */
    public var clockSprite:KbSprite;
    
    var minuteHand:ClockHand;
    
    var hourHand:ClockHand;
    
    public function new():Void{
        super();
        
        clockSprite = new KbSprite(705, 25).createFromImage('assets/images/night/rooms/main/main_clock.png');
        add(clockSprite);
        
        minuteHand = new ClockHand(this, 'Minute');
        add(minuteHand);
        
        hourHand = new ClockHand(this, "Hour");
        add(hourHand);
    }
    
    public function updateHands(minute:Float, hour:Float):Void{
        minuteHand.updateHandPosition(minute);
        hourHand.updateHandPosition(hour);
    }
}
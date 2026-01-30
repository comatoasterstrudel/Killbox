package killbox.game.night.rooms.main.clock;

class Clock extends FlxSpriteGroup
{
    /**
     * the sprite for the actual clock, not hands
     */
    var clockSprite:KbSprite;
    
    public function new():Void{
        super();
        
        clockSprite = new KbSprite(705, 25).createFromImage('assets/images/night/rooms/main/main_clock.png');
        add(clockSprite);
    }
}
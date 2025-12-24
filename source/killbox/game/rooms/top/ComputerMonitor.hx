package killbox.game.rooms.top;

class ComputerMonitor extends FlxSpriteGroup
{
    var timers:Array<FlxTimer> = [];
    
    var screen:FlxSprite;
    
    public function new():Void{
        super();
        
        screen = new FlxSprite(135, 83).makeGraphic(390, 200, FlxColor.LIME);
        add(screen);
    }
    
    public function tranIn():Void{
        resetTimers();

        screen.color = FlxColor.LIME.getDarkened(.8);
        
        for(i in 0...5){
            timers.push(new FlxTimer().start((.3 - (.1 * (GameValues.getComputerSpeed()))) * i, function(f):Void{
                screen.color = FlxColor.LIME.getDarkened(.8 * (1 - (i / 5)));
            }));
        }
    }
    
    public function tranOut():Void{
        resetTimers();
        
        screen.color = FlxColor.LIME;

        for(i in 0...3){
            timers.push(new FlxTimer().start(((GameValues.getMovementSpeed() / 3) / 3) * i, function(f):Void{
                screen.color = FlxColor.LIME.getDarkened(1 * (i / 3));
            }));
        }
    }
    
    function resetTimers():Void{
        for(i in timers){
            if(i != null && i.active) i.cancel();
        }
        
        timers = [];
    }
}
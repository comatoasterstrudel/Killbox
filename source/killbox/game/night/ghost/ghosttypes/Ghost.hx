package killbox.game.night.ghost.ghosttypes;

class Ghost{
    public var name:String;
    public var movementTime:Float;
    
    public var playState:PlayState;
    
    public function new(playState:PlayState, name:String = '', movementTime:Float = .3):Void{
        this.playState = playState;
        this.name = name;
        
        new FlxTimer(PlayState.timerManager).start(movementTime * FlxG.random.float(.8, 1.2), function(f):Void{
            movementOpportunity();
            
            f.reset(movementTime * FlxG.random.float(.8, 1.2));
        });
    }
    
    public function movementOpportunity():Void{
        if(PlayState.GAME_RULES.ghostAiList.list.get(name) > FlxG.random.int(0,20)){
            move();
        }
    }
    
    public function move():Void{
        //
    }
}
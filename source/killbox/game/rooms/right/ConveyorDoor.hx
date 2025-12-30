package killbox.game.rooms.right;

class ConveyorDoor extends FlxSpriteGroup
{
    public var door:FlxSprite;
    
    public var up:Bool = false;
    
    public var trueUp:Bool = false;
    
    public var blocked:Bool = false;
    
    public function new():Void{
        super();
        
        door = new FlxSprite(430, 0).makeGraphic(100, 320, FlxColor.GRAY);
        add(door);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateDoorPosition(elapsed);
    }
    
    function updateDoorPosition(elapsed:Float):Void{
        if(up){
            door.y = Utilities.lerpThing(door.y, -270, elapsed, 15);
        } else {
            door.y = Utilities.lerpThing(door.y, 0, elapsed, 15);
            
            if(blocked && door.y > -70){
                door.y = -70;
            }
        } 
        
        if(door.y < -70){
            trueUp = true;
        } else {
            trueUp = false;
        }
    }
    
    public function updateDoorStatus(up:Bool = true):Void{
        this.up = up;
        
    }
}
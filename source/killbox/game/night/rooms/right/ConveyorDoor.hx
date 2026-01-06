package killbox.game.night.rooms.right;

class ConveyorDoor extends FlxSpriteGroup
{
    public var door:KbSprite;
    
    public var up:Bool = false;
    
    public var trueUp:Bool = false;
    
    public var blocked:Bool = false;
    
    public function new():Void{
        super();
        
        door = new KbSprite(430, 0).createColorBlock(100, 320, FlxColor.GRAY);
        door.lerpManager.lerpY = true;
        door.lerpManager.lerpSpeed = 20;
        add(door);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateDoorPosition(elapsed);
    }
    
    function updateDoorPosition(elapsed:Float):Void{
        if(up){
            door.lerpManager.targetPosition.y = -270;
        } else {
            door.lerpManager.targetPosition.y = 0;
            
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
package killbox.game.night.door;

/**
 * the graphic that goes behind doors in the rooms
 */
class RoomDoor extends FlxSpriteGroup
{
    /**
     * the black sprite that gets displayed behind the door
     */
    var backing:KbSprite;
    
    public function new(doorX:Float, doorY:Float, doorWidth:Int, doorHeight:Int):Void{
        super();
        
        backing = new KbSprite(doorX, doorY).createColorBlock(doorWidth, doorHeight, 0xFF131313);
        add(backing);
    }
}
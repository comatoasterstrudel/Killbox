package killbox.game.rooms.main;

class FlashlightHolder extends FlxSpriteGroup
{
    public var holdingLight:Bool = false;
    
    var holderBack:FlxSprite;
    var holderFront:FlxSprite;
    
    public function new():Void{
        super();
        
        holderBack = new FlxSprite(900, 150).makeGraphic(80, 150, 0xFF353535);
        add(holderBack);
        
        holderFront = new FlxSprite(890, 150);
        add(holderFront);
        
        updateHolderSprite();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(Cursor.mouseIsTouching(holderBack) && FlxG.mouse.justReleased){
            holdingLight = !holdingLight;
            updateHolderSprite();
        }        
    }
    
    function updateHolderSprite():Void{
        if(holdingLight){
            holderFront.loadGraphic('assets/images/night/roomMain/flashHolderFull.png');
        } else {
            holderFront.loadGraphic('assets/images/night/roomMain/flashHolderEmpty.png');
        }
    }
}
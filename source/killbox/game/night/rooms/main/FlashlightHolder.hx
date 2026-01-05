package killbox.game.night.rooms.main;

class FlashlightHolder extends FlxSpriteGroup
{
    public var holdingLight:Bool = false;
    
    var holderBack:KbSprite;
    var holderFront:KbSprite;
    
    public function new():Void{
        super();
        
        holderBack = new KbSprite(900, 150).createColorBlock(80, 150, 0xFF353535);
        add(holderBack);
        
        holderFront = new KbSprite(890, 150);
        add(holderFront);
        
        updateHolderSprite();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
		if (Cursor.mouseIsTouching(holderBack) && PlayState.curRoom == 'main') {
			holderBack.color = 0xFF424242;
			if (FlxG.mouse.justPressed) {
				holdingLight = !holdingLight;
				updateHolderSprite();
			}
		} else {
			holderBack.color = 0xFF353535;
		}    
    }
    
    function updateHolderSprite():Void{
        if(holdingLight){
			holderFront.createFromImage('assets/images/night/rooms/main/flashHolderFull.png');
        } else {
			holderFront.createFromImage('assets/images/night/rooms/main/flashHolderEmpty.png');
        }
    }
}
package killbox.game.night.rooms.main;

class FlashlightHolder extends KbSprite
{
    public var holdingLight:Bool = false;
    
    public function new():Void{
        super(865, -40);
        
        createFromSparrow('assets/images/night/rooms/main/main_flashlightholder.png', 'assets/images/night/rooms/main/main_flashlightholder.xml');
        animation.addByIndices('holding', 'flashlight holder', [0], '');
        animation.addByIndices('notholding', 'flashlight holder', [1], '');
        updateHolderSprite();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
		if (Cursor.mouseIsTouching(this) && PlayState.curRoom == 'main') {
			color = 0xFFC8C8C8;
			if (FlxG.mouse.justPressed) {
				holdingLight = !holdingLight;
				updateHolderSprite();
			}
		} else {
			color = 0xFFD5D1D1;
		}    
    }
    
    function updateHolderSprite():Void{
        if(holdingLight) animation.play('holding'); else animation.play('notholding');
    }
}
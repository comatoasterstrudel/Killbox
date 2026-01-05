package killbox.game.night.rooms.left.cabinet;

/**
 * the door that covers the cabinet.
 * it gets masked within a certain area so that the door can look cool and dynamic
 */
class CabinetDoor extends KbSprite
{
    /**
     * the shader to mask the door
     */
    var maskShader:MaskAlphaShader;
    
    public function new():Void{
        super();
        
        createColorBlock(FlxG.width, FlxG.height, 0xFF262626);
        
        maskShader = new MaskAlphaShader(this, 'assets/images/night/rooms/left/cabinetDoorMask.png');
        shader = maskShader;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        maskShader.update();
    }
    
	/**
	 * call this to open the door
	 * @param onComplete function to run after the animation is complete
	 */
	public function openDoor(onComplete:Void->Void = null):Void {
        FlxTween.cancelTweensOf(this);
        y = 0;
        
		PlayState.tweenManager.tween(this, {y: -300}, GameValues.getCabinetDoorOpenTime(), {ease: FlxEase.quartOut, onComplete: function(F):Void {
			if (onComplete != null)
				onComplete();
        }});
    }
    
    /**
	 * call this to close the door
	 * @param onComplete function to run after the animation is complete
	 */
	public function closeDoor(onComplete:Void->Void = null):Void {
        FlxTween.cancelTweensOf(this);
		y = -300;
        PlayState.tweenManager.tween(this, {y: 0}, GameValues.getCabinetDoorOpenTime(), {ease: FlxEase.quartOut, onComplete: function(F):Void{
            if (onComplete != null)
                onComplete();
        }});
    }
}
package killbox.game.rooms.left;

class CabinetDoor extends FlxSprite
{
    var maskShader:MaskAlphaShader;
    
    public function new():Void{
        super();
        
        makeGraphic(FlxG.width, FlxG.height, 0xFF262626);
        
        maskShader = new MaskAlphaShader(this, 'assets/images/night/rooms/left/cabinetDoorMask.png');
        shader = maskShader;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        maskShader.update();
    }
    
	public function openDoor(onComplete:Void->Void = null):Void {
        FlxTween.cancelTweensOf(this);
        y = 0;
		FlxTween.tween(this, {y: -300}, GameValues.getCabinetDoorOpenTime(), {
			ease: FlxEase.quartOut,
			onComplete: function(F):Void {
				if (onComplete != null)
					onComplete();
        }});
    }
    
	public function closeDoor(onComplete:Void->Void = null):Void {
        FlxTween.cancelTweensOf(this);
		y = -300;
        FlxTween.tween(this, {y: 0}, GameValues.getCabinetDoorOpenTime(), {ease: FlxEase.quartOut, onComplete: function(F):Void{
				if (onComplete != null)
					onComplete();
        }});
    }
}
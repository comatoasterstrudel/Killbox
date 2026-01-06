package killbox.game.night.rooms.right.parts;

class PartDraggable extends KbSprite
{
    var onDrop:PartDraggable->Void;
    
    var holding:Bool = true;
    var finished:Bool = false;
    
    public function new(onDrop:PartDraggable->Void):Void{
        super();
        
        this.onDrop = onDrop;
        
        createColorBlock(20, 20, FlxColor.PINK);
        
        setPosition(FlxG.mouse.screenX - width / 2, FlxG.mouse.screenY - height / 2);
        lerpManager.targetPosition.set(x, y);
        
        lerpManager.lerpX = true;
        lerpManager.lerpY = true;
        lerpManager.lerpSpeed = 12;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
                        
        if(!finished){
            holding = FlxG.mouse.pressed;

            if(holding){
                lerpManager.targetPosition.set(FlxG.mouse.screenX - width / 2, FlxG.mouse.screenY - height / 2);
            } else {
                finish();
            }   
        }
    }
    
    public function finish():Void{
        if(finished) return;
        
        finished = true;
        holding = false;
        onDrop(this);
    }
    
    public function doDropAnim():Void{
        lerpManager.lerpX = false;
        lerpManager.lerpY = false;
        
        PlayState.tweenManager.tween(this, {alpha: 0}, 0.4, {onComplete: function(f):Void{
            this.destroy();
        }});
    }
    
    public function doDepositAnim():Void{
        this.destroy();
    }
}
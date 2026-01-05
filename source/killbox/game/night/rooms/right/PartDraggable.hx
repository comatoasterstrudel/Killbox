package killbox.game.night.rooms.right;

class PartDraggable extends FlxSprite
{
    var onDrop:PartDraggable->Void;
    
    var holding:Bool = true;
    var finished:Bool = false;
    
    public function new(onDrop:PartDraggable->Void):Void{
        super();
        
        this.onDrop = onDrop;
        
        makeGraphic(20, 20, FlxColor.PINK);
        
        this.setPosition(FlxG.mouse.screenX - width / 2, FlxG.mouse.screenY - height / 2);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
                        
        if(!finished){
            holding = FlxG.mouse.pressed;

            if(holding){
                this.setPosition(Utilities.lerpThing(this.x, FlxG.mouse.screenX - width / 2, elapsed, 15), Utilities.lerpThing(this.y, FlxG.mouse.screenY - height / 2, elapsed, 15));
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
        FlxTween.tween(this, {alpha: 0}, 0.4, {onComplete: function(f):Void{
            this.destroy();
        }});
    }
    
    public function doDepositAnim():Void{
        this.destroy();
    }
}
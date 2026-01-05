package killbox.extensions;

/**
 * The replacement for FlxSprite in this project
 */
class KbSprite extends FlxSprite
{
    public var lerpManager:LerpManager;
    
    public function new(?x:Float, ?y:Float, ?antialiasing = true):Void{
        super(x,y);
        
	    this.antialiasing = antialiasing;
        
        lerpManager = new LerpManager(this);
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);

        lerpManager.updateLerps(elapsed);		
	}
    
    public function createFromImage(key:String, size:Float = 1):KbSprite{
        loadGraphic(key);
        resize(size);
        return this;
    }
    
    public function resize(size:Float):Void{
        setGraphicSize(Std.int(this.width * size));
        updateHitbox();
    }
}
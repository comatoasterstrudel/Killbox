package killbox.extensions;

/**
 * The replacement for FlxText in this project
 */
class KbText extends FlxText
{
    public var lerpManager:LerpManager;
    
    public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true, antialiasing:Bool = true):Void{
        super(X,Y,fieldWidth,Text,Size,EmbeddedFont);
        
	    this.antialiasing = antialiasing;
        
        lerpManager = new LerpManager(this);
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);

        lerpManager.updateLerps(elapsed);		
	}
}
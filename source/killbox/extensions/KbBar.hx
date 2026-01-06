package killbox.extensions;

/**
 * The replacement for FlxBar in this project
 */
class KbBar extends FlxBar
{
    public var lerpManager:LerpManager;

    public function new(x:Float = 0, y:Float = 0, ?direction:FlxBarFillDirection, width:Int = 100, height:Int = 10, ?parentRef:Dynamic, variable:String = "", min:Float = 0, max:Float = 100, showBorder:Bool = false, antialiasing:Bool = true):Void{
        super(x, y, direction, width, height, parentRef, variable, min, max, showBorder);
        
        this.antialiasing = antialiasing;
        
        lerpManager = new LerpManager(this);
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);

        lerpManager.updateLerps(elapsed);		
	}
    
    public function createFromImage(emptyKey:String, fullKey:String, size:Float = 1):KbBar{
        createImageBar(emptyKey, fullKey);
        resize(size);
        return this;
    }
    
    public function createColorBar(emptyColor:FlxColor, fillColor:FlxColor, size:Float = 1):KbBar{
        createColoredEmptyBar(emptyColor);
        createColoredFilledBar(fillColor);
        resize(size);
        return this;
    }
    
    public function resize(size:Float):Void{
        setGraphicSize(Std.int(this.width * size));
        updateHitbox();
    }
    
    public function setNumDivisionsToSize():Void{
        switch(fillDirection){
            case LEFT_TO_RIGHT | RIGHT_TO_LEFT | HORIZONTAL_INSIDE_OUT | HORIZONTAL_OUTSIDE_IN: //Horizontal
                numDivisions = Std.int(width);
            case TOP_TO_BOTTOM | BOTTOM_TO_TOP | VERTICAL_INSIDE_OUT | VERTICAL_OUTSIDE_IN: //Vertical
                numDivisions = Std.int(height);
            default:
                //
        }
    }
}
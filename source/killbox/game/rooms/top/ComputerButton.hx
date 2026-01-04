package killbox.game.rooms.top;

class ComputerButton extends FlxText
{
    var page:ComputerPage;
    
    var realX:Int = 0;
    
    var realY:Int = 0;
    
    var realText:String = '';
    
    var pressedFunction:Void->Void;
    
	public var pressable:Bool = true;
    
    public function new(page:ComputerPage, realX:Int, realY:Int, realText:String, pressedFunction:Void->Void):Void{
        super();
        
        this.page = page;
        this.realX = realX;
        this.realY = realY;
        this.realText = realText;
        this.pressedFunction = pressedFunction;
        
        setFormat(15, FlxColor.GREEN);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
                
		if (page.active && visible && FlxG.mouse.overlaps(this) && pressable) {
            alpha = 1;
            text = '>  ' + realText;
            
            if(FlxG.mouse.justPressed){
                pressedFunction();
            }
        } else {
            alpha = .5;
            text = realText;
        }
        
        setPosition(realX, realY);
    }
}
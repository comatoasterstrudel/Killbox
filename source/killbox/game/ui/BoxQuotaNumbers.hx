package killbox.game.ui;

class BoxQuotaNumbers extends FlxSpriteGroup
{
    var numbers:Array<BoxQuotaNumber> = [];
    
    public function new():Void{
        super();
        
        for(i in 0...Constants.BOX_QUOTA_DISPLAY_DIGITS){
            var number = new BoxQuotaNumber();
            number.ID = i;
            add(number);
            numbers.push(number);
        }
    }
    
    public function updateText(number:Int, x:Int, y:Int):Void{
        var text = Utilities.stringToArray(Std.string(number));
        
        var curX:Int = x;
        
        for(i in numbers){
            if(i.ID >= text.length){
                i.inUse = false;
                continue;
            } else {
                i.inUse = true;
                
                i.updateText(Std.parseInt(text[i.ID]), curX, y);
                curX += Std.int(i.width + 3);
            }
        }
    }
    
    public function getWidth():Float{
        var theWidth:Float = 0;
        
        for(i in numbers){
            if(!i.inUse) continue;
            
            theWidth += i.width;
            theWidth += 3;
        }
        
        return theWidth;
    }
}
package killbox.game.night.ui.boxquota;

/**
 * the numbers on each side of the divider 
 * for the BoxQuotaText
 */
class BoxQuotaNumbers extends FlxSpriteGroup
{
    /**
     * the number sprites
     */
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
    
    /**
     * call this to update the numbers displayed on these text objects
     * @param number the number to display. (up to 5 digits)
     * @param x x position
     * @param y y position
     */
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
    
    /**
     * call this to get the width of all of the numbers currently being displayed
     * @return width of all numbers
     */
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
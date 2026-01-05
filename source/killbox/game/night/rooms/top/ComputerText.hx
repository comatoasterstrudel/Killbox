package killbox.game.night.rooms.top;

class ComputerText extends FlxText
{
    var page:ComputerPage;
    
    var realX:Int = 0;
    
    var realY:Int = 0;
    
    var realText:String = '';
        
    public function new(page:ComputerPage, realX:Int, realY:Int, realText:String):Void{
        super();
        
        this.page = page;
        x = realX;
        y = realY;
        text = realText;
        
        setFormat(15, FlxColor.GREEN);
    }
}
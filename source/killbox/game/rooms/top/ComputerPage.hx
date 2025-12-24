package killbox.game.rooms.top;

class ComputerPage extends FlxSpriteGroup
{
    public var pageActive:Bool = false;
    
    public var name:String;
    
    var changePage:String->Void;
        
    var screen:FlxSprite;
    
    public function new(name:String, changePage:String->Void, screen:FlxSprite):Void{
        super();
        
        this.name = name;
        this.changePage = changePage;
        this.screen = screen;
        
        setupPage();
    }
    
    public static function createPage(name:String, changePage:String->Void, screen:FlxSprite):ComputerPage
    {
        switch(name){
            case 'main':
                return new ComputerPageMain(name, changePage, screen);
            case 'finishProduction':
                return new ComputerPageFinishProduction(name, changePage, screen);
            default:
                return new ComputerPage(name, changePage, screen);                
        }
    }
    
    function addButton(xPos:Int, yPos:Int, text:String, pressedFunction:Void->Void):Void{
        add(new ComputerButton(this, xPos, yPos, text, pressedFunction));
    }
    
    function setupPage():Void{
        //
    }
}
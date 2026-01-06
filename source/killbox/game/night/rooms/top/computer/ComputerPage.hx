package killbox.game.night.rooms.top.computer;

class ComputerPage extends FlxSpriteGroup
{
    public var pageActive:Bool = false;
    
    public var name:String;
    
    var changePage:String->Void;
        
    var screen:KbSprite;
    
    public function new(name:String, changePage:String->Void, screen:KbSprite):Void{
        super();
        
        this.name = name;
        this.changePage = changePage;
        this.screen = screen;
        
        setupPage();
    }

	function addButton(xPos:Int, yPos:Int, text:String, pressedFunction:Void->Void):ComputerButton {
		var button = new ComputerButton(this, xPos, yPos, text, pressedFunction);
		add(button);
		return button;
    }
    
    function setupPage():Void{
        //
    }
}
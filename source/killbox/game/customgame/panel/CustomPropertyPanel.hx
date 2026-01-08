package killbox.game.customgame.panel;

class CustomPropertyPanel extends FlxSpriteGroup
{
    public var bg:KbSprite;
    public var label:KbText;
    public var number:KbText;
    
    var upArrow:CustomPropertyPanelArrow;
    var downArrow:CustomPropertyPanelArrow;
    
    var labelText:String;
    
    public var value:Int = 0;
    public var min:Int;
    public var max:Int;
    
    public function new(x:Float, y:Float, labelText:String, min:Int, max:Int):Void{
        super();
        
        this.labelText = labelText;
        this.min = min;
        this.max = max;
        
        bg = new KbSprite(x, y).createColorBlock(150, 120, 0xFF464646);
        add(bg);
        
        label = new KbText(0,0, 0, labelText, 20);
        label.setPosition(bg.x + bg.width / 2 - label.width / 2, bg.y - label.height - 5);
        add(label);
       
        upArrow = new CustomPropertyPanelArrow(this, UP);
        add(upArrow);
        
        downArrow = new CustomPropertyPanelArrow(this, DOWN);
        add(downArrow);
        
        number = new KbText(0,0,0,'', 30);
        number.scale.x = 1.5;
        number.updateHitbox();
        add(number);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        number.text = Std.string(value);
        number.setPosition(bg.x + bg.width / 2 - number.width / 2, bg.y + bg.height / 2 - number.height / 2);
    }
}
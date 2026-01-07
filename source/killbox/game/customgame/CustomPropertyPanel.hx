package killbox.game.customgame;

class CustomPropertyPanel extends FlxSpriteGroup
{
    public var bg:KbSprite;
    public var label:KbText;
    public var number:KbText;
    
    var upArrow:KbSprite;
    var downArrow:KbSprite;
    
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
        
        upArrow = new KbSprite().createFromImage('assets/images/customgame/arrow.png');
        upArrow.setPosition(bg.x + bg.width / 2 - upArrow.width / 2, bg.y + 3);
        add(upArrow);
        
        downArrow = new KbSprite().createFromImage('assets/images/customgame/arrow.png');
        downArrow.flipY = true;
        downArrow.setPosition(bg.x + bg.width / 2 - upArrow.width / 2, bg.y + bg.height - downArrow.height - 3);
        add(downArrow);
        
        number = new KbText(0,0,0,'', 30);
        number.scale.x = 1.5;
        number.updateHitbox();
        add(number);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(value > min){
            if(Cursor.mouseIsTouching(downArrow)){
                if(FlxG.mouse.justPressed){
                    value --;
                }
                downArrow.color = 0xFFA7A7A7;
            } else {
                downArrow.color = 0xFFFFFFFF;
            }   
        } else {
            downArrow.color = 0xFF3C3C3C;
        }
        
        if(value < max){
            if(Cursor.mouseIsTouching(upArrow)){
                if(FlxG.mouse.justPressed){
                    value ++;
                }
                upArrow.color = 0xFFA7A7A7;
            } else {
                upArrow.color = 0xFFFFFFFF;
            }   
        } else {
            upArrow.color = 0xFF3C3C3C;
        }
        
        number.text = Std.string(value);
        number.setPosition(bg.x + bg.width / 2 - number.width / 2, bg.y + bg.height / 2 - number.height / 2);
    }
}
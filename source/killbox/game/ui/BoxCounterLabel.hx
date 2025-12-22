package killbox.game.ui;

class BoxCounterLabel extends FlxSpriteGroup
{
    public var boxes:Array<FlxSprite> = [];
    
    var text:FlxText;
    var bg:FlxSprite;
    
	var yOffset:Float = 100;

	public function new(boxes:Array<FlxSprite>, yOffset:Float = 100):Void {
        super();

        visible = false;
        
        bg = new FlxSprite().loadGraphic('assets/images/night/boxCounterBg.png');
        add(bg);
        
        text = new FlxText(0,0,0,'', 25);
        add(text);
        
		this.boxes = boxes;
		this.yOffset = yOffset;

        updateLabel();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateLabel();
    }
    
    public function updateLabel():Void{
        if(boxes.length > 1){
            visible = true;
            text.text = Std.string(boxes.length);
            var xPos:Array<Float> = [];
            var yPos:Array<Float> = [];
            for(i in boxes){
                xPos.push(i.x + i.width / 2);
                yPos.push(i.y + i.height / 2);
            }
			text.setPosition(Utilities.getAverage(xPos) - text.width / 2, (Utilities.getAverage(yPos) - text.height / 2) - yOffset);
            bg.setPosition(text.x + text.width / 2 - bg.width / 2, text.y + text.height / 2 - bg.height / 2);
            text.y -= 10;
        } else {
            visible = false;
        }
    }
}
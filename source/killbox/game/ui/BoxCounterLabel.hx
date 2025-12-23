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
        
		bg = new FlxSprite().loadGraphic('assets/images/night/ui/boxCounterBg.png');
        add(bg);
        
        text = new FlxText(0,0,0,'', 25);
        add(text);
        
		this.boxes = boxes;
		this.yOffset = yOffset;

		alpha = 0;

		updateLabel(FlxG.elapsed);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
		updateLabel(elapsed);
    }
    
	public function updateLabel(elapsed:Float):Void {
        if(boxes.length > 1){
            visible = true;
            text.text = Std.string(boxes.length);
            var xPos:Array<Float> = [];
            var yPos:Array<Float> = [];
            for(i in boxes){
                xPos.push(i.x + i.width / 2);
                yPos.push(i.y + i.height / 2);
            }
			var targetPosition = new FlxPoint(Utilities.getAverage(xPos) - text.width / 2, (Utilities.getAverage(yPos) - text.height / 2) - yOffset);
			text.setPosition(Utilities.lerpThing(text.x, targetPosition.x, elapsed, 15), Utilities.lerpThing(text.y, targetPosition.y, elapsed, 15));
			alpha = Utilities.lerpThing(alpha, 1, elapsed, 5);
            bg.setPosition(text.x + text.width / 2 - bg.width / 2, text.y + text.height / 2 - bg.height / 2);
            text.y -= 10;
        } else {
            visible = false;
			alpha = 0;
        }
    }
}
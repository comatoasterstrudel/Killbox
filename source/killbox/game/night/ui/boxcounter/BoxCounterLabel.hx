package killbox.game.night.ui.boxcounter;

/**
 * the label sprites put ontop of groups of boxes.
 * controlled by BoxCounter
 */
class BoxCounterLabel extends FlxSpriteGroup
{
    /**
     * sprites
     */
    public var bg:KbSprite;
    public var text:KbText;
 
    /**
     * which boxes are being tracked by this label
     */
    public var boxes:Array<FlxSprite> = [];
    
	/**
	 * the amount that the label is moved from the boxes
	 */
	var yOffset:Float;

	public function new(boxes:Array<FlxSprite>, yOffset:Float = 100):Void {
        super();

        visible = false;
        
		bg = new KbSprite().createFromImage('assets/images/night/ui/boxCounterBg.png');
        bg.alpha = 0;
        add(bg);
        
        text = new KbText(0,0,0,'', 25);
        text.lerpManager.lerpX = true;
        text.lerpManager.lerpY = true;
        text.lerpManager.lerpAlpha = true;
        text.lerpManager.targetAlpha = 1;
        text.lerpManager.lerpSpeed = 15;
        text.alpha = 0;
        add(text);
        
		this.boxes = boxes;
		this.yOffset = yOffset;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(boxes.length > 1){
            visible = true;
            text.text = Std.string(boxes.length);
            var xPos:Array<Float> = [];
            var yPos:Array<Float> = [];
            for(i in boxes){
                xPos.push(i.x + i.width / 2);
                yPos.push(i.y + i.height / 2);
            }
			text.lerpManager.targetPosition.set(Utilities.getAverage(xPos) - text.width / 2, (Utilities.getAverage(yPos) - text.height / 2) - yOffset);
        } else {
            visible = false;
			text.alpha = 0;
        }
        
        bg.setPosition(text.x + text.width / 2 - bg.width / 2, (text.y + text.height / 2 - bg.height / 2) + 10);
        bg.alpha = text.alpha;
    }
}
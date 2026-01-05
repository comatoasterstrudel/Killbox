package killbox.game.night.rooms.left;

/**
 * the press that presses down materials into boxes
 */
class BoxPress extends FlxSpriteGroup
{
    /**
     * sprites
     */
    public var pressTop:KbSprite;
	public var pressBottom:KbSprite;
    
    /**
     * is the press currently pressing?
     */
    public var pressing:Bool = false;

	/**
	 * should boxes be blocked from going through the press right now?
	 */
	public var blockBoxes:Bool = false;

	/**
	 * function to be called when the press is fully down
	 */
	var pressBoxes:Void->Void;

	public function new(pressBoxes:Void->Void):Void
	{
        super();

		this.pressBoxes = pressBoxes;

        pressTop = new KbSprite().createColorBlock(215, 500, 0xFF1D1D1D);
		add(pressTop);
		
		pressBottom = new KbSprite(0, 80).createColorBlock(270, 60, 0xFF303030);
		add(pressBottom);
        
        updateBoxPressPosition();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateBoxPressPosition();
    }
    
    /**
     * call this to adjust the press sprites position according to the bottom of it
     */
    function updateBoxPressPosition():Void{
        pressTop.x = 100;
		pressBottom.x = pressTop.x + pressTop.width / 2 - pressBottom.width / 2;
		pressTop.y = pressBottom.y - pressTop.height;
    }
    
    /**
     * call this to start the box press animation
     */
    public function startBoxPress():Void{
		var pressSpeed = GameValues.getPressSpeed();
        
        pressing = true;
		PlayState.tweenManager.tween(pressBottom, {y: 60 + 260}, pressSpeed / 6, {
			ease: FlxEase.quartOut,
			onUpdate: (function(f):Void
			{
				if (f.percent >= .5 && !blockBoxes)
				{
					blockBoxes = true;
					pressBoxes();
				}
			}),
			onComplete: function(f):Void
			{
				PlayState.tweenManager.tween(pressBottom, {y: 60}, pressSpeed / 6, {
					startDelay: (pressSpeed / 6) * 5,
					ease: FlxEase.quartOut,
					onUpdate: (function(f):Void
					{
						if (f.percent <= .8 && blockBoxes)
						{
							blockBoxes = false;
						}
					}),
					onComplete: function(f):Void
					{
						pressing = false;
						blockBoxes = false;
			}});
		}});
	}
}
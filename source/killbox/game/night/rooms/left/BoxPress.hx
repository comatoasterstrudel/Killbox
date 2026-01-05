package killbox.game.night.rooms.left;

class BoxPress extends FlxSpriteGroup
{
    public var pressTop:FlxSprite;
	public var pressBottom:FlxSprite;
    
    public var pressing:Bool = false;

	public var blockBoxes:Bool = false;

	var pressBoxes:Void->Void;

	public function new(pressBoxes:Void->Void):Void
	{
        super();

		this.pressBoxes = pressBoxes;

        pressTop = new FlxSprite().makeGraphic(215, 500, 0xFF1D1D1D);
		add(pressTop);
		
		pressBottom = new FlxSprite(0, 80).makeGraphic(270, 60, 0xFF303030);
		add(pressBottom);
        
        updateBoxPressPosition();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateBoxPressPosition();
    }
    
    function updateBoxPressPosition():Void{
        pressTop.x = 100;
		pressBottom.x = pressTop.x + pressTop.width / 2 - pressBottom.width / 2;
		pressTop.y = pressBottom.y - pressTop.height;
    }
    
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
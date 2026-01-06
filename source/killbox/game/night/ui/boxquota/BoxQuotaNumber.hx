package killbox.game.night.ui.boxquota;

/**
 * the numbers used on the box quota object
 */
class BoxQuotaNumber extends KbText
{
	/**
	 * if this object should be hidden 
	 * and skipped during width calculation
	 */
	public var inUse:Bool = false;

	/**
	 * the number this text represented on the last frame
	 */
	var lastNumber:Int = 0;

	/**
	 * the current offset that needs to be added to the y position
	 */
	var yOffset:Int = 0;

	public function new():Void {
		super(0, 0, 0, '2', 50);
	}
	
	override function update(elapsed:Float):Void {
		super.update(elapsed);

		visible = inUse;
	}

	/**
	 * call this to update this text object
	 * @param number which number to apply to the sprite
	 * @param x x position
	 * @param y y position
	 */
	public function updateText(number:Int, x:Int, y:Int):Void {
		this.text = Std.string(number);
		setPosition(x, y + yOffset);

		if (lastNumber != number) {
			yOffset = (lastNumber < number || lastNumber == 9 && number == 0) ? -15 : 15;
			PlayState.tweenManager.cancelTweensOf(this);
			PlayState.tweenManager.tween(this, {yOffset: 0}, .67, {ease: FlxEase.quartOut});
		}

		lastNumber = number;
	}
}
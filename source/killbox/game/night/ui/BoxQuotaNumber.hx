package killbox.game.night.ui;

class BoxQuotaNumber extends KbText
{
	public var inUse:Bool = false;

	var lastNumber:Int = 0;

	var yOffset:Int = 0;

	public function new():Void {
		super(0, 0, 0, '2', 50);
	}

	public function updateText(number:Int, x:Int, y:Int):Void {
		this.text = Std.string(number);
		setPosition(x, y + yOffset);

		if (lastNumber != number) {
			yOffset = (lastNumber < number || lastNumber == 9 && number == 0) ? -15 : 15;
			FlxTween.cancelTweensOf(this);
			FlxTween.tween(this, {yOffset: 0}, .67, {ease: FlxEase.quartOut});
		}

		lastNumber = number;
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		visible = inUse;
	}
}
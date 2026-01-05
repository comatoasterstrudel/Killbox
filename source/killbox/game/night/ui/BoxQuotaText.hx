package killbox.game.night.ui;

class BoxQuotaText extends FlxSpriteGroup
{
	var leftNumbers:BoxQuotaNumbers;
    var divider:FlxText;
	var rightNumbers:BoxQuotaNumbers;

	public function new():Void {
		super();

		leftNumbers = new BoxQuotaNumbers();
		add(leftNumbers);

		divider = new FlxText(0, 0, 0, '/', 50);
		add(divider);

		rightNumbers = new BoxQuotaNumbers();
		add(rightNumbers);

		updateText(0, 3, 0, 0, 0);

		angle = -8;
	}

	public function updateText(boxesProduced:Int, quota:Int, x:Int, y:Int, alpha:Float):Void {
		leftNumbers.updateText(boxesProduced, x, y);
		divider.setPosition(Std.int(x + leftNumbers.getWidth() + 30), y);
		rightNumbers.updateText(quota, Std.int(divider.x + divider.width + 33), y);
		for (i in leftNumbers.members) {
			i.alpha = alpha;
		}
		divider.alpha = alpha;
		for (i in rightNumbers.members) {
			i.alpha = alpha;
		}
	}
	public function getWidth():Float {
		return (leftNumbers.getWidth() + 63 + divider.width + rightNumbers.getWidth());
	}
}
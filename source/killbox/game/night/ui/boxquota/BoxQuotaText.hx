package killbox.game.night.ui.boxquota;

/**
 * the text to be displayed on the BoxQuotaDisplay
 */
class BoxQuotaText extends FlxSpriteGroup
{
	/**
	 * sprites
	 */
	var leftNumbers:BoxQuotaNumbers;
    var divider:KbText;
	var rightNumbers:BoxQuotaNumbers;

	public function new():Void {
		super();

		leftNumbers = new BoxQuotaNumbers();
		add(leftNumbers);

		divider = new KbText(0, 0, 0, '/', 50);
		add(divider);

		rightNumbers = new BoxQuotaNumbers();
		add(rightNumbers);

		updateText(0, 3, 0, 0, 0);

		angle = -8;
	}

	/**
	 * call this to update all of the numbers on this display
	 * @param boxesProduced how many boxes have been produced
	 * @param quota how many boxes you need to produce
	 * @param x x position
	 * @param y y position
	 * @param alpha the alpha of these sprites
	 */
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
	
	/**
	 * call this to get the width of all number and text objects
	 * @return the width of all number and text objects
	 */
	public function getWidth():Float {
		return (leftNumbers.getWidth() + 63 + divider.width + rightNumbers.getWidth());
	}
}
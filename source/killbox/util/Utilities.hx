package killbox.util;

class Utilities{
    public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15, ?roundNum:Float = 0.001):Float
	{
		var num = FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
		
		if(num + roundNum >= target && initialnum < target || num - roundNum <= target && initialnum > target) num = target;
		 
		return num;
	}
	public static function getAverage(data:Array<Float>):Float
	{
		var sum:Float = 0;
		for (value in data)
		{
			sum += value;
		}
		return (sum / data.length);
	}
	public static function centerGroup(array:Array<FlxSprite>, spacing:Float, ?xpos:Float):Void {
		if (xpos == null) {
			xpos = FlxG.width / 2;
		}

		var centerX:Float = xpos;

		var members:Array<Dynamic> = array;

		var count:Int = members.length;
		if (count == 0)
			return;

		// Calculate the total width of all sprites including spacing
		var totalWidth:Float = 0;

		for (i in members) {
			totalWidth += i.width;
			totalWidth += spacing;
		}
		// Start positioning from the leftmost point
		var startX:Float = centerX - totalWidth / 2;

		var thex = startX;

		for (i in 0...count) {
			var sprite = members[i];
			sprite.x = (thex + (spacing)) - sprite.width / 3;
			thex = sprite.x + sprite.width;
		}
	}

	public static function stringToArray(text:String):Array<String> {
		var thing = new StringIteratorUnicode(text);

		var returnthis:Array<String> = [];

		for (i in thing) {
			returnthis.push(String.fromCharCode(i));
		}

		return returnthis;
	}
}
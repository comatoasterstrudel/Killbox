package killbox.util;

class Utilities{
    public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15):Float
	{
		return FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
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
}
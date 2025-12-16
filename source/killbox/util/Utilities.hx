package killbox.util;

class Utilities{
    public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15):Float
	{
		return FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
	}
}
package killbox.util;

/**
 * class used to manage lerps for a sprite!! cool
 */
class LerpManager
{
	/**
	 * the target values for this sprite
	 */
	public var targetAlpha:Float = 0;
    public var targetPosition:FlxPoint = new FlxPoint();
    public var targetScale:FlxPoint = new FlxPoint();
    
	/**
	 * booleans determining whether or not to lerp certain values
	 */
	public var lerpAlpha:Bool = false;
	public var lerpX:Bool = false;
	public var lerpY:Bool = false;
	public var lerpScaleX:Bool = false;
	public var lerpScaleY:Bool = false;
	
	/**
	 * the values that the lerps result in. you can use these even if this manager isnt directly tied to a sprite!!
	 */
	public var alpha:Float = 0;
	public var x:Float = 0;
	public var y:Float = 0;
	public var scaleX:Float = 0;
	public var scaleY:Float = 0;

	/**
	 * a speed at which the lerps happen
	 */
	public var lerpSpeed:Float  = 20;
    
    /**
     * sprite this lerp manager is for. this is optional!!
     */
    var sprite:FlxSprite;
    
    public function new(?sprite:FlxSprite):Void{
		if(sprite != null) this.sprite = sprite;
    }
    
    /**
	 * call this to update this sprites properties to their target properties, if needed
	 * @param elapsed time since last frame
	 */
    public function updateLerps(elapsed:Float):Void{
       	if (lerpAlpha) alpha = Utilities.lerpThing(alpha, targetAlpha, elapsed, lerpSpeed);
		if (lerpX && targetPosition != null) x = Utilities.lerpThing(x, targetPosition.x, elapsed, lerpSpeed);
		if (lerpY && targetPosition != null) y = Utilities.lerpThing(y, targetPosition.y, elapsed, lerpSpeed);
		if (lerpScaleX && targetScale != null) scaleX = Utilities.lerpThing(scaleX, targetScale.x, elapsed, lerpSpeed);
		if (lerpScaleY && targetScale != null) scaleY = Utilities.lerpThing(scaleY, targetScale.y, elapsed, lerpSpeed);		
		
		updateSprite();
	}
	
	/**
	 * call this to snap the sprite to its target position
	 */
	public function snap():Void{
		if (lerpAlpha) alpha = targetAlpha;
		if (lerpX && targetPosition != null) x = targetPosition.x;
		if (lerpY && targetPosition != null) y = targetPosition.y;
		if (lerpScaleX && targetScale != null) scaleX = targetScale.x;
		if (lerpScaleY && targetScale != null) scaleY = targetScale.y;	
		
		updateSprite();
	}
	
	/**
	 * call this to set the values from this LerpManager to the sprite
	 */
	function updateSprite():Void{
		if(sprite == null) return;
		
		if (lerpAlpha) sprite.alpha = alpha;
		if (lerpX) sprite.x = x;
		if (lerpY) sprite.y = y;
		if (lerpScaleX) sprite.scale.x = scaleY;
		if (lerpScaleY) sprite.scale.y = scaleY;	
	}
}
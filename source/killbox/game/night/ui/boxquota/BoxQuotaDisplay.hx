package killbox.game.night.ui.boxquota;

/**
 * ui element to display how many boxes youve produced, 
 * and what the quota is
 */
class BoxQuotaDisplay extends FlxSpriteGroup
{
	/**
	 * sprites
	 */
	var backShadow:KbSprite;
	var boxSprite:KbSprite;
    var boxQuotaText:BoxQuotaText;

	/**
     * the original positions for the sprites
     */
    var shadowPosition:FlxPoint;
	var boxPosition:FlxPoint;
	var textPosition:FlxPoint;

	/**
	 * lerp manager for the text,
	 * instead of using lerps on each individual text object
	 */
	var textLerpManager:LerpManager;
	
	/**
	 * how many boxes were produced as of the last frame
	 */
	var lastBoxesProduced:Int = 0;
	
	/**
	 * what the quota was as of the last frame
	 */
	var lastQuota:Int = 3;
	
	/**
    * how long since the box values have changed, 
    * used to determine when this ui element should drop off the screen
    */
    var timeSinceLastChange:Float = Constants.BOX_QUOTA_DISPLAY_INACTIVITY_TIME;
    
	public function new(curBoxesProduced:Int, curQuota:Int):Void {
        super();
        
        backShadow = new KbSprite().createFromImage('assets/images/night/ui/boxProgress_back.png', .8);
		backShadow.setPosition(0, FlxG.height - backShadow.height);
        backShadow.alpha = .8;
		backShadow.lerpManager.lerpX = true;
		backShadow.lerpManager.lerpY = true;
		backShadow.lerpManager.lerpAlpha = true;
        add(backShadow);
        
		boxSprite = new KbSprite().createFromImage('assets/images/night/ui/boxSprite.png', 1.1);
		boxSprite.setPosition(-20, FlxG.height - 125);
		boxSprite.lerpManager.lerpX = true;
		boxSprite.lerpManager.lerpY = true;
		boxSprite.lerpManager.lerpAlpha = true;
		add(boxSprite);

		boxQuotaText = new BoxQuotaText();
		add(boxQuotaText);
        
		textLerpManager = new LerpManager();
		textLerpManager.lerpX = true;
		textLerpManager.lerpY = true;
		textLerpManager.lerpAlpha = true;
		
        shadowPosition = new FlxPoint(backShadow.x, backShadow.y);
		boxPosition = new FlxPoint(boxSprite.x, boxSprite.y);
		textPosition = new FlxPoint(30, FlxG.height - 80);

		lastBoxesProduced = curBoxesProduced;
		lastQuota = curQuota;
		updateDisplay(curBoxesProduced, curQuota, FlxG.elapsed, true);
    }
    
	/**
	 * call this to update this displays info
	 * @param curBoxesProduced the current amount of boxes produced
	 * @param curQuota the current box quota
	 * @param elapsed time since last frame in ms
	 * @param snap should the sprites snap into place?
	 */
	public function updateDisplay(curBoxesProduced:Int, curQuota:Int, elapsed:Float, snap:Bool = false):Void {        
        if(curBoxesProduced == lastBoxesProduced && curQuota == lastQuota){
            timeSinceLastChange += elapsed;
        } else {
            timeSinceLastChange = 0;
        }
        
        lastBoxesProduced = curBoxesProduced;
        lastQuota = curQuota;
        		
        configurePositions(elapsed, snap);
    }
    
	/**
     * call this to set the values for the sprites. 
     * this is in its own function since its long.
     */
    public function configurePositions(elapsed:Float, snap:Bool = false):Void{ 
        if(timeSinceLastChange < Constants.BOX_QUOTA_DISPLAY_INACTIVITY_TIME){ // show it
			backShadow.lerpManager.targetPosition.set(shadowPosition.x, shadowPosition.y);
			backShadow.lerpManager.targetAlpha = .8;
            backShadow.lerpManager.lerpSpeed = 12;
			
			boxSprite.lerpManager.targetPosition.set(boxPosition.x, boxPosition.y);
			boxSprite.lerpManager.targetAlpha = 1;
            boxSprite.lerpManager.lerpSpeed = 12;

			textLerpManager.targetPosition.set(textPosition.x, textPosition.y);
			textLerpManager.targetAlpha = 1;
            textLerpManager.lerpSpeed = 12;
          } else { //hide it
            backShadow.lerpManager.targetPosition.set(shadowPosition.x - 40, shadowPosition.y + 40);
			backShadow.lerpManager.targetAlpha = .0;
            backShadow.lerpManager.lerpSpeed = 5;
			
			boxSprite.lerpManager.targetPosition.set(boxPosition.x - 50, boxPosition.y + 40);
			boxSprite.lerpManager.targetAlpha = 0;
            boxSprite.lerpManager.lerpSpeed = 5;

			textLerpManager.targetPosition.set(textPosition.x - 100, textPosition.y + 100);
			textLerpManager.targetAlpha = 0;
            textLerpManager.lerpSpeed = 5;
        }
		
        if(snap){
			backShadow.lerpManager.snap();
			boxSprite.lerpManager.snap();
			textLerpManager.snap();
        }
		
		textLerpManager.updateLerps(elapsed);
		boxQuotaText.updateText(lastBoxesProduced, lastQuota, Std.int(textLerpManager.x), Std.int(textLerpManager.y), textLerpManager.alpha);

		backShadow.setGraphicSize(60 + boxQuotaText.getWidth(), backShadow.height);
		backShadow.updateHitbox();
    }
}
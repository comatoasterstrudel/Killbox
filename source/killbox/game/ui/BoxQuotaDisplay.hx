package killbox.game.ui;

class BoxQuotaDisplay extends FlxSpriteGroup
{
	var backShadow:FlxSprite;
	var boxSprite:FlxSprite;
    
    var shadowPosition:FlxPoint;

    var backShadowTargetPosition:FlxPoint;
    var backShadowTargetAlpha:Float;
    
	var textTargetPosition:FlxPoint;
	var textTargetAlpha:Float;

	var textPosition:FlxPoint;
	var textAlpha:Float = 1;
    
    var lerpSpeed:Float = 1;

    var timeSinceLastChange:Float = Constants.BOX_QUOTA_DISPLAY_INACTIVITY_TIME;
    
    var lastBoxesProduced:Int = 0;
    var lastQuota:Int = 0;
    
	var boxQuotaText:BoxQuotaText;
    
    public function new():Void{
        super();
        
        backShadow = new FlxSprite().loadGraphic('assets/images/night/ui/boxProgress_back.png');
        backShadow.alpha = .8;
        backShadow.setGraphicSize(Std.int(backShadow.width * .8));
        backShadow.updateHitbox();
        backShadow.setPosition(0, FlxG.height - backShadow.height);
        add(backShadow);
        
		boxSprite = new FlxSprite('assets/images/night/ui/boxSprite.png');
		boxSprite.setGraphicSize(Std.int(boxSprite.width * 1.1));
		boxSprite.updateHitbox();
		boxSprite.setPosition(0, FlxG.height - boxSprite.height);
		add(boxSprite);

		boxQuotaText = new BoxQuotaText();
		add(boxQuotaText);
        
        shadowPosition = new FlxPoint(backShadow.x, backShadow.y);
        
        backShadowTargetPosition = new FlxPoint();
        
		textTargetPosition = new FlxPoint();

		textPosition = new FlxPoint(30, FlxG.height - 80);

		updateSprites(0, 0, FlxG.elapsed, true);
    }
    
	public function updateSprites(curBoxesProduced:Int, curQuota:Int, elapsed:Float, snap:Bool = false):Void {        
        if(curBoxesProduced == lastBoxesProduced && curQuota == lastQuota){
            timeSinceLastChange += elapsed;
        } else {
            timeSinceLastChange = 0;
        }
        
        lastBoxesProduced = curBoxesProduced;
        lastQuota = curQuota;
        
        if(timeSinceLastChange < Constants.BOX_QUOTA_DISPLAY_INACTIVITY_TIME){ // show it
            lerpSpeed = 12;
            
            backShadowTargetAlpha = .8;
            backShadowTargetPosition.set(shadowPosition.x, shadowPosition.y);
			textTargetAlpha = 1;
			textTargetPosition.set(30, FlxG.height - 80);
          } else { //hide it
            lerpSpeed = 5;
            
            backShadowTargetAlpha = 0;
            backShadowTargetPosition.set(shadowPosition.x - 40, shadowPosition.y + 40);
			textTargetAlpha = 0;
			textTargetPosition.set(-10, FlxG.height);
        }
        
        updatePosition(elapsed, snap);
    }
    
    public function updatePosition(elapsed:Float, snap:Bool = false):Void{
        if(snap){
            backShadow.alpha = backShadowTargetAlpha;
            backShadow.setPosition(backShadowTargetPosition.x, backShadowTargetPosition.y);
			textAlpha = textTargetAlpha;
			textPosition.set(textTargetPosition.x, textTargetPosition.y);
        } else {
            backShadow.alpha = Utilities.lerpThing(backShadow.alpha, backShadowTargetAlpha, elapsed, lerpSpeed);
            backShadow.setPosition(Utilities.lerpThing(backShadow.x, backShadowTargetPosition.x, elapsed, lerpSpeed), Utilities.lerpThing(backShadow.y, backShadowTargetPosition.y, elapsed, lerpSpeed));
			textAlpha = Utilities.lerpThing(textAlpha, textTargetAlpha, elapsed, lerpSpeed);
			textPosition.set(Utilities.lerpThing(textPosition.x, textTargetPosition.x, elapsed, lerpSpeed),
				Utilities.lerpThing(textPosition.y, textTargetPosition.y, elapsed, lerpSpeed));
        }
		boxQuotaText.updateText(lastBoxesProduced, lastQuota, Std.int(textPosition.x), Std.int(textPosition.y), textAlpha);

		boxSprite.alpha = textAlpha;
		boxSprite.setPosition(backShadow.x, backShadow.y);
    }
}
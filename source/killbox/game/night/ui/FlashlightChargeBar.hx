package killbox.game.night.ui;

class FlashlightChargeBar extends FlxSpriteGroup
{
    var backShadow:FlxSprite;
    var bar:FlxBar;
    var barOutline:FlxSprite;
    
    var flashCharge:Float = 1;
    
    public var timeSinceLastChange:Float = Constants.FLASHLIGHT_CHARGE_BAR_INACTIVITY_TIME;
    
    var shadowPosition:FlxPoint;
    var barPosition:FlxPoint;
    
    var backShadowTargetPosition:FlxPoint;
    var backShadowTargetAlpha:Float;
    
    var barTargetPosition:FlxPoint;
    var barTargetAlpha:Float;
    
    var lerpSpeed:Float = 1;
    
    var previousHoldingLight:Bool = true;
    
    public function new():Void{
        super();
                
        backShadow = new FlxSprite().loadGraphic('assets/images/night/ui/lightBar_back.png');
        backShadow.alpha = .8;
        backShadow.setGraphicSize(Std.int(backShadow.width * .8));
        backShadow.updateHitbox();
        backShadow.setPosition(FlxG.width - backShadow.width, FlxG.height - backShadow.height);
        add(backShadow);
        
        bar = new FlxBar(FlxG.width - 181, FlxG.height - 281, BOTTOM_TO_TOP, 134, 230, this, "flashCharge", 0, 1);
        bar.createImageBar('assets/images/night/ui/lightBar_empty.png', 'assets/images/night/ui/lightBar_full.png');
        bar.numDivisions = Std.int(bar.height);
        bar.updateBar();
        bar.scale.set(.65, .65);
        bar.updateHitbox();
        bar.angle = 8;
        bar.setPosition(FlxG.width - 120, FlxG.height - 180);
        add(bar);
        
        barOutline = new FlxSprite().loadGraphic('assets/images/night/ui/lightBar_outline.png');
        barOutline.scale.set(.65, .65);
        barOutline.updateHitbox();
        barOutline.angle = 8;
        add(barOutline);
        
        shadowPosition = new FlxPoint(backShadow.x, backShadow.y);
        barPosition = new FlxPoint(bar.x, bar.y);
        
        backShadowTargetPosition = new FlxPoint();
        barTargetPosition = new FlxPoint();
        
        updateBar(1,1,FlxG.elapsed,true, true);
    }
    
    public function updateBar(curCharge:Float, maxCharge:Float, elapsed:Float, holdingLight:Bool, snap:Bool = false):Void{
        var newFlashCharge = (curCharge / maxCharge);
        
        if(newFlashCharge == flashCharge){
            timeSinceLastChange += elapsed;
        } else {
            timeSinceLastChange = 0;
        }
        
        flashCharge = newFlashCharge;
        
        if(previousHoldingLight != holdingLight){
            timeSinceLastChange = 0;
        }
        previousHoldingLight = holdingLight;
        
        if(timeSinceLastChange < Constants.FLASHLIGHT_CHARGE_BAR_INACTIVITY_TIME){ // show it
            lerpSpeed = 12;
            
            backShadowTargetAlpha = .8;
            barTargetAlpha = 1;
            backShadowTargetPosition.set(shadowPosition.x, shadowPosition.y);
            barTargetPosition.set(barPosition.x, barPosition.y);      
          } else { //hide it
            lerpSpeed = 5;
            
            backShadowTargetAlpha = 0;
            barTargetAlpha = 0;
            backShadowTargetPosition.set(shadowPosition.x + 40, shadowPosition.y + 40);
            barTargetPosition.set(barPosition.x + 80, barPosition.y + 80);
        }
        
        updatePosition(elapsed, snap);
    }
    
    public function updatePosition(elapsed:Float, snap:Bool = false):Void{
        if(snap){
            backShadow.alpha = backShadowTargetAlpha;
            bar.alpha = barTargetAlpha;
            backShadow.setPosition(backShadowTargetPosition.x, backShadowTargetPosition.y);
            bar.setPosition(barTargetPosition.x, barTargetPosition.y);
        } else {
            backShadow.alpha = Utilities.lerpThing(backShadow.alpha, backShadowTargetAlpha, elapsed, lerpSpeed);
            bar.alpha = Utilities.lerpThing(bar.alpha, barTargetAlpha, elapsed, lerpSpeed);
            backShadow.setPosition(Utilities.lerpThing(backShadow.x, backShadowTargetPosition.x, elapsed, lerpSpeed), Utilities.lerpThing(backShadow.y, backShadowTargetPosition.y, elapsed, lerpSpeed));
            bar.setPosition(Utilities.lerpThing(bar.x, barTargetPosition.x, elapsed, lerpSpeed), Utilities.lerpThing(bar.y, barTargetPosition.y, elapsed, lerpSpeed));
        }
        barOutline.setPosition(bar.x + bar.width / 2 - barOutline.width / 2, bar.y + bar.height / 2 - barOutline.height / 2);
        barOutline.alpha = bar.alpha;
    }
}

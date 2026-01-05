package killbox.game.night.ui;

/**
 * ui element to display how charged the flashlight is
 */
class FlashlightChargeBar extends FlxSpriteGroup
{
    /**
     * sprites
     */
    var backShadow:KbSprite;
    var bar:KbBar;
    var barOutline:KbSprite;
    
    /**
     * the original positions for the sprites
     */
    var shadowPosition:FlxPoint;
    var barPosition:FlxPoint;
    
    /**
     * the value to represent how charged the flashlight is, 
     * from 0 to 1
     */
    var flashCharge:Float = 1;
    
    /**
     * was the flashlight in your hand last frame?
     */
    var previousHoldingLight:Bool = true;
    
    /**
     * how long since the flashlight values have changed, 
     * used to determine when this ui element should drop off the screen
     */
    public var timeSinceLastChange:Float = Constants.FLASHLIGHT_CHARGE_BAR_INACTIVITY_TIME;
    
    public function new():Void{
        super();
                
        backShadow = new KbSprite().createFromImage('assets/images/night/ui/lightBar_back.png', .8);
        backShadow.alpha = .8;
        backShadow.setPosition(FlxG.width - backShadow.width, FlxG.height - backShadow.height);
        backShadow.lerpManager.lerpX = true;
        backShadow.lerpManager.lerpY = true;
        backShadow.lerpManager.lerpAlpha = true;
        add(backShadow);
        
        bar = new KbBar(FlxG.width - 181, FlxG.height - 281, BOTTOM_TO_TOP, 134, 230, this, "flashCharge", 0, 1).createFromImage('assets/images/night/ui/lightBar_empty.png', 'assets/images/night/ui/lightBar_full.png', .65);
        bar.setPosition(FlxG.width - 120, FlxG.height - 180);
        bar.setNumDivisionsToSize();
        bar.angle = 8;
        bar.lerpManager.lerpX = true;
        bar.lerpManager.lerpY = true;
        bar.lerpManager.lerpAlpha = true;
        add(bar);
        
        barOutline = new KbSprite().createFromImage('assets/images/night/ui/lightBar_outline.png', .65);
        barOutline.angle = 8;
        add(barOutline);
        
        shadowPosition = new FlxPoint(backShadow.x, backShadow.y);
        barPosition = new FlxPoint(bar.x, bar.y);
        
        updateBar(1,1,FlxG.elapsed,true, true);
    }
    
    /**
     * call this to update this bars info
     * @param curCharge the flashlights charge this frame
     * @param maxCharge the maximum charge for the flashlight
     * @param elapsed time since last frame in ms
     * @param holdingLight are you holding the flashlight on this frame?
     * @param snap should the sprites snap into place?
     */
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
        
        configurePositions(snap);
    }
    
    /**
     * call this to set the values for the sprites. 
     * this is in its own function since its long.
     */
    function configurePositions(snap:Bool):Void{
        if(timeSinceLastChange < Constants.FLASHLIGHT_CHARGE_BAR_INACTIVITY_TIME){ // show it
            backShadow.lerpManager.targetPosition.set(shadowPosition.x, shadowPosition.y);
            backShadow.lerpManager.targetAlpha = .8;
            backShadow.lerpManager.lerpSpeed = 12;
            
            bar.lerpManager.targetPosition.set(barPosition.x, barPosition.y);
            bar.lerpManager.targetAlpha = 1;
            bar.lerpManager.lerpSpeed = 12;    
        } else { //hide it
            backShadow.lerpManager.targetPosition.set(shadowPosition.x + 40, shadowPosition.y + 40);
            backShadow.lerpManager.targetAlpha = .0;
            backShadow.lerpManager.lerpSpeed = 5;
            
            bar.lerpManager.targetPosition.set(barPosition.x + 80, barPosition.y + 80);
            bar.lerpManager.targetAlpha = 0;
            bar.lerpManager.lerpSpeed = 5;    
        }
             
        if(snap) backShadow.lerpManager.snap();
        if(snap) bar.lerpManager.snap();
        
        barOutline.setPosition(bar.x + bar.width / 2 - barOutline.width / 2, bar.y + bar.height / 2 - barOutline.height / 2);
        barOutline.alpha = bar.alpha;
    }
}

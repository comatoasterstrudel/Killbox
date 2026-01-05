package killbox.game.ui;

class BoxQuotaDisplay extends FlxSpriteGroup
{
    var backShadow:FlxSprite;
    var textObjects:Array<FlxText> = [];
    
    var shadowPosition:FlxPoint;

    var backShadowTargetPosition:FlxPoint;
    var backShadowTargetAlpha:Float;
    
    var lerpSpeed:Float = 1;

    var timeSinceLastChange:Float = Constants.BOX_QUOTA_DISPLAY_INACTIVITY_TIME;
    
    var lastBoxesProduced:Int = 0;
    var lastQuota:Int = 0;
    
    public function new():Void{
        super();
        
        backShadow = new FlxSprite().loadGraphic('assets/images/night/ui/boxProgress_back.png');
        backShadow.alpha = .8;
        backShadow.setGraphicSize(Std.int(backShadow.width * .8));
        backShadow.updateHitbox();
        backShadow.setPosition(0, FlxG.height - backShadow.height);
        add(backShadow);
        
        shadowPosition = new FlxPoint(backShadow.x, backShadow.y);
        
        backShadowTargetPosition = new FlxPoint();
        
        updateBar(0,0,FlxG.elapsed, true);
    }
    
    public function updateBar(curBoxesProduced:Int, curQuota:Int, elapsed:Float, snap:Bool = false):Void{        
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
          } else { //hide it
            lerpSpeed = 5;
            
            backShadowTargetAlpha = 0;
            backShadowTargetPosition.set(shadowPosition.x - 40, shadowPosition.y + 40);
        }
        
        updatePosition(elapsed, snap);
    }
    
    public function updatePosition(elapsed:Float, snap:Bool = false):Void{
        if(snap){
            backShadow.alpha = backShadowTargetAlpha;
            backShadow.setPosition(backShadowTargetPosition.x, backShadowTargetPosition.y);
        } else {
            backShadow.alpha = Utilities.lerpThing(backShadow.alpha, backShadowTargetAlpha, elapsed, lerpSpeed);
            backShadow.setPosition(Utilities.lerpThing(backShadow.x, backShadowTargetPosition.x, elapsed, lerpSpeed), Utilities.lerpThing(backShadow.y, backShadowTargetPosition.y, elapsed, lerpSpeed));
        }
    }
}
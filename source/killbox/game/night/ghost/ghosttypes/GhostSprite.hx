package killbox.game.night.ghost.ghosttypes;

class GhostSprite extends KbSprite
{
    public var maxHp:Int;
    public var hp:Float;
    
    public var playState:PlayState;
    public var parent:FlxSpriteGroup;
    
    public function new(playState:PlayState, parent:FlxSpriteGroup, maxHp:Int = 50):Void{
        super();
        
        this.playState = playState;
        this.parent = parent;
        
        this.maxHp = maxHp;
        hp = maxHp; 
        
        makeGraphic(50, 50, 0xFF7FB8B7);
        
        lerpManager.lerpScaleX = true;
        lerpManager.lerpScaleY = true;
        lerpManager.targetScale.set(1,1);
        lerpManager.lerpSpeed = 3;
        scale.set(0, 0);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(visible && FlxG.overlap(this, playState.flashlightSprite) && playState.flashlightActive){
            var distanceMult:Float = (1.5 - (FlxMath.bound(FlxMath.distanceBetween(this, playState.flashlightSprite) / FlxG.width, 0, 1)));
            
            hp -= (elapsed * (GameValues.getFlashlightDamage() * distanceMult));
            if(hp < 0){
                die();
            }            
        } else {
            hp += elapsed * 50;
            if(hp > maxHp) hp = maxHp;
        }
        
        alpha = (hp / maxHp);
    }
    
    public function die():Void{
        parent.remove(this, true);
        destroy();
    }
}
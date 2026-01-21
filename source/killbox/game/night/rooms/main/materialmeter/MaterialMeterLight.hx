package killbox.game.night.rooms.main.materialmeter;

/**
 * the individual light sprites for the material meter
 */
class MaterialMeterLight extends FlxSpriteGroup
{
    /**
     * sprites
     */
    public var lightSprite:KbSprite;
	public var whiteOverlay:KbSprite;
    
    /**
     * the status of this light. (ON vs CHARGING vs OFF)
     */
    var status:MaterialMeterLightStatus = ON;

    public function new(ID:Int):Void{
        super();
        this.ID = ID;
        
        lightSprite = new KbSprite().createFromSparrow('assets/images/night/rooms/main/main_materiallight.png', 'assets/images/night/rooms/main/main_materiallight.xml');
        lightSprite.animation.addByIndices('active', 'materialmeter', [0], '');
        lightSprite.animation.addByIndices('inactive', 'materialmeter', [1], '');
		lightSprite.y = 320;
        add(lightSprite);
        
		whiteOverlay = new KbSprite().createFromSparrow('assets/images/night/rooms/main/main_materiallight.png', 'assets/images/night/rooms/main/main_materiallight.xml');
        whiteOverlay.animation.addByIndices('active', 'materialmeter', [0], '');
        whiteOverlay.animation.play('active');
        whiteOverlay.alpha = 0;
        whiteOverlay.lerpManager.lerpAlpha = true;
        whiteOverlay.lerpManager.targetAlpha = 0;
        whiteOverlay.lerpManager.lerpSpeed = 4;
        add(whiteOverlay);
    }
    
    /**
     * call this to update the values for this sprite
     * @param availableMaterials how many materials are available for use
     * @param timeUntilNextMaterial how long until the next material will be ready
     */
    public function updateMaterialMeter(availableMaterials:Int, timeUntilNextMaterial:Float):Void{
        if(availableMaterials >= ID){
            lightSprite.color = 0xFFC5F9C4;
            if(status != ON) whiteOverlay.alpha = .7;
            if(whiteOverlay.alpha > 0) whiteOverlay.setPosition(lightSprite.x, lightSprite.y);
            status = ON;
            lightSprite.animation.play('active');
        } else if(ID == availableMaterials + 1){ //this one is charging
            lightSprite.color = FlxColor.LIME.getDarkened((.8) * 1 - (timeUntilNextMaterial / GameValues.getMaterialRefillTime()));
            status = CHARGING;
            whiteOverlay.alpha = 0;
            lightSprite.animation.play('inactive');
        } else {
            lightSprite.color = FlxColor.LIME.getDarkened(.8);
            status = OFF;
            whiteOverlay.alpha = 0;
            lightSprite.animation.play('inactive');
        }                
    }
}
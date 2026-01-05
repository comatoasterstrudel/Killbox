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
        
        lightSprite = new KbSprite().createColorBlock(25, 25, FlxColor.LIME);
		lightSprite.setPosition((200 + (50 * (ID - 1))), 250);
        add(lightSprite);
        
		whiteOverlay = new KbSprite().createColorBlock(25, 25, FlxColor.WHITE);
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
            if(whiteOverlay.alpha > 0) whiteOverlay.setPosition(lightSprite.x, lightSprite.y);
            lightSprite.color = FlxColor.LIME;
            if(status != ON) whiteOverlay.alpha = .7;
            status = ON;
        } else if(ID == availableMaterials + 1){ //this one is charging
            lightSprite.color = FlxColor.GREEN.getDarkened((.8) * 1 - (timeUntilNextMaterial / GameValues.getMaterialRefillTime()));
            status = CHARGING;
            whiteOverlay.alpha = 0;
        } else {
            lightSprite.color = FlxColor.GREEN.getDarkened(.8);
            status = OFF;
            whiteOverlay.alpha = 0;
        }        
    }
}
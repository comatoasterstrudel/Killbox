package killbox.game.night.rooms.main;

class MaterialMeterLight extends FlxSpriteGroup
{
    var flashTimer:Float = 0;
    
    var status:MaterialMeterLightStatus = ON;
    
	public var lightSprite:FlxSprite;
	public var whiteOverlay:FlxSprite;
    
    public function new(ID:Int):Void{
        super();
        this.ID = ID;
        
        lightSprite = new FlxSprite().makeGraphic(25, 25, FlxColor.LIME);
		lightSprite.setPosition((200 + (50 * (ID - 1))), 250);
        add(lightSprite);
        
		whiteOverlay = new FlxSprite().makeGraphic(25, 25, FlxColor.WHITE);
        whiteOverlay.alpha = 0;
        add(whiteOverlay);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(flashTimer > 0){
            flashTimer -= elapsed;
        }
        
        if(flashTimer < 0){
            flashTimer = 0;
        }        
    }
    
    public function updateMaterialMeter(availableMaterials:Int, timeUntilNextMaterial:Float):Void{
        if(availableMaterials >= ID){
            lightSprite.color = FlxColor.LIME;
            if(status != ON) flashTimer = .7;
            status = ON;
            whiteOverlay.alpha = flashTimer;
			whiteOverlay.setPosition(lightSprite.x, lightSprite.y);
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
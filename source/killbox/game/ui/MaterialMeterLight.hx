package killbox.game.ui;

class MaterialMeterLight extends FlxSprite
{
    var flashTimer:Float = 0;
    
    var status:MaterialMeterLightStatus = ON;
    
    public function new(ID:Int):Void{
        super();
        this.ID = ID;
        makeGraphic(25, 25, FlxColor.LIME);
        setPosition((200 + (50 * (ID - 1))), 400);
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
            color = FlxColor.LIME.getLightened(flashTimer);
            if(status != ON) flashTimer = 1;
            status = ON;
        } else if(ID == availableMaterials + 1){ //this one is charging
            color = FlxColor.GREEN.getDarkened((.8) * 1 - (timeUntilNextMaterial / GameValues.getMaterialRefillTime()));
            status = CHARGING;
        } else {
            color = FlxColor.GREEN.getDarkened(.8);
            status = OFF;
        }
    }
}
package killbox.game.night.rooms.main.materialmeter;

/**
 * sprites that display how many materials are available,
 * and how long until the next material.
 */
class MaterialMeter extends FlxTypedSpriteGroup<MaterialMeterLight>
{
	public function new(button:FlxSprite):Void {
        super();
        
        for(i in 0...GameValues.getMaxMaterials()){
            var lightSprite = new MaterialMeterLight(i + 1);
            add(lightSprite);
        }
		var sprites:Array<FlxSprite> = [];
		for (i in members) {
			sprites.push(i.lightSprite);
		}
		Utilities.centerGroup(sprites, -30, 550);
    }
    
    /**
     * call this to update the values for the lights
     * @param availableMaterials how many materials are available for use
     * @param timeUntilNextMaterial how long until the next material will be ready
     */
    public function updateMaterialMeter(availableMaterials:Int, timeUntilNextMaterial:Float):Void{
        for(i in members){
            i.updateMaterialMeter(availableMaterials, timeUntilNextMaterial);
        }
    }
}
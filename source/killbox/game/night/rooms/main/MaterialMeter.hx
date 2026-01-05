package killbox.game.night.rooms.main;

class MaterialMeter extends FlxTypedSpriteGroup<MaterialMeterLight>
{
	public function new(button:FlxSprite):Void {
        super();
        
        for(i in 0...GameValues.getMaxMaterials()){
            var lightSprite = new MaterialMeterLight(i + 1);
            add(lightSprite);
        }
		var sprites = [];
		for (i in members) {
			sprites.push(i.lightSprite);
		}
		Utilities.centerGroup(sprites, 40, button.x + button.width / 2);
    }
    
    public function updateMaterialMeter(availableMaterials:Int, timeUntilNextMaterial:Float):Void{
        for(i in members){
            i.updateMaterialMeter(availableMaterials, timeUntilNextMaterial);
        }
    }
}
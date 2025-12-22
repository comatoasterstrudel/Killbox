package killbox.game.ui;

class MaterialMeter extends FlxTypedSpriteGroup<MaterialMeterLight>
{
    public function new():Void{
        super();
        
        for(i in 0...GameValues.getMaxMaterials()){
            var lightSprite = new MaterialMeterLight(i + 1);
            add(lightSprite);
        }
    }
    
    public function updateMaterialMeter(availableMaterials:Int, timeUntilNextMaterial:Float):Void{
        for(i in members){
            i.updateMaterialMeter(availableMaterials, timeUntilNextMaterial);
        }
    }
}
package killbox.game.night.rooms.right.parts;

class PartBox extends FlxSpriteGroup
{
    var box:KbSprite;
    
    var interactable:Bool = true;
    
    public var partDraggable:PartDraggable;
    
    var partReceptor:PartReceptor;
    
    public function new(partReceptor:PartReceptor):Void{
        super();
        
        this.partReceptor = partReceptor;
        
        box = new KbSprite(350, 450).createColorBlock(200,100,0xFF2F3940);
        add(box);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateBoxPosition();
        
        if(interactable){
            if(Cursor.mouseIsTouching(box)){
                if(FlxG.mouse.justPressed){
                    box.scale.set(1.2, .8);
                    PlayState.tweenManager.cancelTweensOf(box.scale);
                    PlayState.tweenManager.tween(box.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quartOut});
                    updateBoxPosition();
                    generatePart();
                }
                box.color = 0xFF1F252A;
            } else {
                box.color = 0xFF2F3940;
            }
        } else {
            box.color = 0xFF2F3940;
        }
    }
    
    function generatePart():Void{
        interactable = false;
        partDraggable = new PartDraggable(function(part:PartDraggable):Void{
            interactable = true;
            
			if (Cursor.mouseIsTouching(partReceptor.depositHere, false)) {
                if(partReceptor.depositPart()){
                    part.doDepositAnim();
                } else {
                    part.doDropAnim();
                }
            } else {
                part.doDropAnim();
            }
        });
        add(partDraggable);
    }
    
    function updateBoxPosition():Void{
        box.updateHitbox();
        box.x = 350 + 100 - box.width / 2;
        box.y = 450 + 100 - box.height;
    }
}
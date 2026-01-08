package killbox.game.customgame.panel;

class CustomPropertyPanelArrow extends KbSprite
{
    var panel:CustomPropertyPanel;
    var type:CustomPropertyPanelArrowType;
    
    var holding:Bool = false;
    
    var holdTimer:Float = 0;
    var maxHoldTimer:Float = .2;
    
    public function new(panel:CustomPropertyPanel, type:CustomPropertyPanelArrowType):Void{
        super();
        
        this.panel = panel;
        this.type = type;
        
        createFromImage('assets/images/customgame/arrow.png');
        
        flipY = (type == DOWN);
        
        setPosition(panel.bg.x + panel.bg.width / 2 - width / 2, (type == UP ? panel.bg.y + 3 : panel.bg.y + panel.bg.height - height - 3));
    }
    
    override function update(elapsed):Void{
        super.update(elapsed);
        
        if(type == DOWN ? (panel.value > panel.min) : (panel.value < panel.max)){
            if(Cursor.mouseIsTouching(this)){
                if(FlxG.mouse.justPressed || FlxG.mouse.pressed && holding){
                    if(!holding || holdTimer >= maxHoldTimer){
                        holdTimer = 0;
                        panel.value += (type == UP ? (1) : (-1));
                        if(holding){
                            maxHoldTimer = .1;
                        } else {
                            maxHoldTimer = .25;
                            holding = true;                            
                        }
                    }
                    holdTimer += elapsed;
                } else {
                    holding = false;
                }
                color = 0xFFA7A7A7;
            } else {
                holding = false;
                color = 0xFFFFFFFF;
            }   
        } else {
            holding = false;
            color = 0xFF3C3C3C;
        }   
    }
}
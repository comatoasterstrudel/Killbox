package killbox.game.rooms.right;

class ConfirmationKeypad extends FlxSpriteGroup
{
    var padBg:FlxSprite;
    var padStand:FlxSprite;
    
    var buttons:Array<ConfirmationKeypadButton> = [];
    
    public function new():Void{
        super();
        
        padBg = new FlxSprite(670, 340).makeGraphic(120, 160, 0xFFC4C4C4);
        
        padStand = new FlxSprite().makeGraphic(70, 30, 0xFF807C7C);
        padStand.setPosition(padBg.x + padBg.width / 2 - padStand.width / 2, padBg.y + padBg.height);
        add(padStand);
        
        add(padBg);
        
        addButtons();
    }
    
    function addButtons():Void{
        var xID:Int = 0;
        var yID:Int = 0;
        
        for(i in 0...10){
            if(i == 0){
                xID = 1;
                yID = 3;
            }
            
            var button = new ConfirmationKeypadButton(padBg, '$i', 0xFFFFFFFF, xID, yID, function():Void{
                
            });
            add(button);
            
            if(i == 0){
                xID = 0;
                yID = 0;
            } else {
                xID ++;
            
                if(xID > 2) {
                    xID = 0;
                    yID ++;
                }   
            }            
        }
        
        var button = new ConfirmationKeypadButton(padBg, 'confirm', 0xFFADDDB8, 2, 3, function():Void{
                
        });
        add(button);
        
        var button = new ConfirmationKeypadButton(padBg, 'cancel', 0xFFDDADAD, 0, 3, function():Void{
                
        });
        add(button);
    }
}
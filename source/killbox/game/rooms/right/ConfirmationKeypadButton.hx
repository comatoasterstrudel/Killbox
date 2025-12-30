package killbox.game.rooms.right;

class ConfirmationKeypadButton extends FlxSprite
{
    var theColor:FlxColor;
    var onPressed:Void->Void;
    
    public function new(padBg:FlxSprite, name:String, theColor:FlxColor, xID:Int = 0, yID:Int = 0, onPressed:Void->Void):Void{
        super();
        
        this.theColor = theColor;
        this.onPressed = onPressed;
        
        makeGraphic(25, 25, theColor);
        
        setPosition(padBg.x + padBg.width / 2 - this.width / 2, (padBg.y + padBg.height / 2 - this.height / 2) - 20);
        
        switch(FlxMath.bound(xID, 0, 2)){
            case 0:
                x -= 40;
            case 2:
                x += 40;
        }
        
        switch(FlxMath.bound(yID, 0, 3)){
            case 0:
                y -= 40;
            case 2:
                y += 40;
            case 3:
                y += 80;
        }
        
        color = theColor;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(Cursor.mouseIsTouching(this)){
            color = theColor.getDarkened(.2);
            
            if(FlxG.mouse.justPressed){
                onPressed();
            }
        } else {
            color = theColor;
        }
    }
}
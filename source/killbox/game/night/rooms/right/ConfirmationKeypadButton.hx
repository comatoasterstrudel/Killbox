package killbox.game.night.rooms.right;

class ConfirmationKeypadButton extends FlxSpriteGroup
{
    var theColor:FlxColor;
    var onPressed:Void->Void;
    
	var button:FlxSprite;
	var label:FlxText;

	public var enabled:Bool = true;
    
    public function new(padBg:FlxSprite, name:String, theColor:FlxColor, xID:Int = 0, yID:Int = 0, onPressed:Void->Void):Void{
        super();
        
        this.theColor = theColor;
        this.onPressed = onPressed;
        
		button = new FlxSprite().makeGraphic(25, 25, theColor);
		button.setPosition(padBg.x + padBg.width / 2 - button.width / 2, (padBg.y + padBg.height / 2 - button.height / 2) - 20);
		add(button);
        
        switch(FlxMath.bound(xID, 0, 2)){
            case 0:
				button.x -= 40;
            case 2:
				button.x += 40;
        }
        
        switch(FlxMath.bound(yID, 0, 3)){
            case 0:
				button.y -= 40;
            case 2:
				button.y += 40;
            case 3:
				button.y += 80;
        }
        
		button.color = theColor;

		label = new FlxText(button.x + 3, button.y + 3, 0, name, 8);

		while (label.width > (button.width - 4)) {
			label.scale.x -= 0.1;
			label.updateHitbox();
		}

		label.setPosition(button.x + button.width / 2 - label.width / 2, button.y + button.height / 2 - label.height / 2);
		add(label);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
		if (enabled) {
			if (Cursor.mouseIsTouching(button)) {
				button.color = theColor.getDarkened(.2);

				if (FlxG.mouse.justPressed) {
					onPressed();
				}
			} else {
				button.color = theColor;
			}

			label.color = button.color.getDarkened(.5);
		} else {
			button.color = theColor.getDarkened(.5);
			label.color = button.color.getDarkened(.15);
		}
    }
}
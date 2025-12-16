package killbox.game.rooms;

class LeftRoom extends Room
{
    override function setupRoom():Void{        
		var coolSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF6C9CB3);
		add(coolSprite);   
        
		var textFart = new FlxText(0, 0, 0, 'this is the left room !');
		textFart.screenCenter();
		add(textFart);
        
        possibleMovements = [
            RIGHT => 'main'
        ];
    }
}
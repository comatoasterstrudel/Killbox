package killbox.game.rooms.top;

class TopRoom extends Room
{
    override function setupRoom():Void{        
		var coolSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xffe3bf69);
		add(coolSprite);   
        
		var textFart = new FlxText(0, 0, 0, 'this is the top room!');
		textFart.screenCenter();
		add(textFart);
        
        possibleMovements = [
            DOWN => 'main'
        ];
    }
}
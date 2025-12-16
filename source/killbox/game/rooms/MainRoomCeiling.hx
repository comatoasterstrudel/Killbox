package killbox.game.rooms;

class MainRoomCeiling extends Room
{
    override function setupRoom():Void{        
        var coolSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
        add(coolSprite);
        
        possibleMovements = [
            DOWN => 'main'
        ];
    }
}
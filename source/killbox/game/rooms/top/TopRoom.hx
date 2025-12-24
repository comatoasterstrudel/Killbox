package killbox.game.rooms.top;

import haxe.macro.Expr.ComplexType;

class TopRoom extends Room
{
	var bgBack:FlxSprite;
	var bgFront:FlxSprite;

	var wiresBack:FlxSprite;
	var wiresFront:FlxSprite;

	var computerMonitor:ComputerMonitor;
	var monitorFront:FlxSprite;

	var interactable:Bool = false;
    
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomBack.png');
		bgBack.screenCenter();
		add(bgBack);

		bgFront = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomFront.png');
		bgFront.screenCenter();
		add(bgFront);

		wiresBack = new FlxSprite().loadGraphic('assets/images/night/rooms/top/tvRoomWiresBack.png');
		wiresBack.screenCenter();
		add(wiresBack);

		wiresFront = new FlxSprite().loadGraphic('assets/images/night/rooms/top/tvRoomWiresFront.png');
		wiresFront.screenCenter();
		add(wiresFront);

		computerMonitor = new ComputerMonitor();
		add(computerMonitor);
        
		monitorFront = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomMonitor.png');
		monitorFront.screenCenter();
		add(monitorFront); 
        
        possibleMovements = [
            DOWN => 'main'
        ];
    }
	override function update(elapsed:Float):Void {
		super.update(elapsed);

		bgBack.scrollFactor.set(.8, .8);

		wiresBack.scrollFactor.set(1.1, 1.1);
		wiresFront.scrollFactor.set(1.2, 1.2);

		computerMonitor.scrollFactor.set(1.3, 1.3);
		monitorFront.scrollFactor.set(1.3, 1.3);
	}

	override function enterRoom():Void {
		interactable = false;

		computerMonitor.tranIn();
	}

	override function leaveRoom():Void {
		interactable = false;

		computerMonitor.tranOut();
	}
}
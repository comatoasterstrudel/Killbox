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

	var topTube:FlxSprite;
	var boxSprites:FlxSpriteGroup;

	var boxCounter:BoxCounter;
	
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomBack.png');
		bgBack.screenCenter();
		add(bgBack);

		bgFront = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topRoomFront.png');
		bgFront.screenCenter();
		add(bgFront);

		boxSprites = new FlxSpriteGroup();
		add(boxSprites);

		topTube = new FlxSprite().loadGraphic('assets/images/night/rooms/top/topTube.png');
		add(topTube);

		boxCounter = new BoxCounter(this, boxSprites, 10);
		add(boxCounter);
		
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
		topTube.scrollFactor.set(1.1, 1.1);

		if (roomActive) {
			#if debug
			if (FlxG.keys.justPressed.ONE) {
				var box = new Box(playState.getBoxID());
				playState.boxes.push(box);
				sendBox(box.ID, RIGHT_TO_TOP);
			}
			#end
		}
	}

	override function sendBox(id:Int, boxSendType:BoxSendType):Void {
		if (boxSendType == RIGHT_TO_TOP) {
			new FlxTimer().start(GameValues.roomTravelTime(), function(f):Void {
				spawnBox(id);
			});
		}
	}

	function spawnBox(id:Int):Void {
		var boxSprite = new FlxSprite(FlxG.width, 60).makeGraphic(36, 36, 0xFF424242);
		boxSprite.ID = id;
		boxSprite.velocity.x = -GameValues.getTubeSpeed();
		boxSprite.angularVelocity = FlxG.random.float(-20, -200);
		boxSprites.add(boxSprite);

		playState.getBoxByID(id).status = RIGHT_FALLING;
	}

	override function enterRoom():Void {
		computerMonitor.tranIn();
	}

	override function leaveRoom():Void {
		computerMonitor.tranOut();
	}
}
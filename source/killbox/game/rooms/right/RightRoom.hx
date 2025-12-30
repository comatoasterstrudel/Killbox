package killbox.game.rooms.right;

class RightRoom extends Room
{
	var bgBack:FlxSprite;
	var bgTube:FlxSprite;
	var bgFront:FlxSprite;
    
	var boxSprites:FlxSpriteGroup;

	var doorButton:FlxSprite;
	var conveyorDoor:ConveyorDoor;

	var boxCounter:BoxCounter;
	
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/rooms/right/rightRoomBg.png');
		bgBack.screenCenter();
		add(bgBack);

		conveyorDoor = new ConveyorDoor();
		add(conveyorDoor);

		boxSprites = new FlxSpriteGroup();
		add(boxSprites);

		boxCounter = new BoxCounter(this, boxSprites, 30);
		add(boxCounter);
		
		bgTube = new FlxSprite().loadGraphic('assets/images/night/rooms/right/rightRoomTube.png');
		bgTube.screenCenter();
		add(bgTube);

		bgFront = new FlxSprite().loadGraphic('assets/images/night/rooms/right/rightRoomFrontDesk.png');
		bgFront.screenCenter();
		add(bgFront);   
		
		doorButton = new FlxSprite(158, 400).makeGraphic(70, 50, 0xFFB5F3CE);
		add(doorButton);
        
        possibleMovements = [
            LEFT => 'main'
        ];
    }
	override function update(elapsed:Float):Void {
		super.update(elapsed);

		for (i in [bgBack, conveyorDoor, boxSprites]) {
			i.scrollFactor.set(0.6, 0.6);
		}
		
		bgTube.scrollFactor.set(0.8, 0.8);
		if (roomActive) {
			#if debug
			if (FlxG.keys.justPressed.ONE) {
				var box = new Box(playState.getBoxID());
				playState.boxes.push(box);
				sendBox(box.ID, LEFT_BACK_TO_RIGHT);
			}
			#end
		}

		manageDoorButton();
		manageConveyors();
	}

	function manageDoorButton():Void {
		if (Cursor.mouseIsTouching(doorButton)) {
			if (FlxG.mouse.pressed) {
				doorButton.color = 0xFF3C915E;

				conveyorDoor.updateDoorStatus(true);
			} else {
				doorButton.color = 0xFF90C7A6;

				conveyorDoor.updateDoorStatus(false);
			}
		} else {
			doorButton.color = 0xFFB5F3CE;
			conveyorDoor.updateDoorStatus(false);
		}
	}

	function manageConveyors():Void {
		conveyorDoor.blocked = false;

		for (box in boxSprites) {
			if (playState.getBoxByID(box.ID).status == RIGHT_FALLING) {
				if (box.y >= 240) {
					box.y = 240;
					box.acceleration.y = 0;
					box.velocity.y = 0;
					box.velocity.x = GameValues.getConveyorSpeed();
					playState.getBoxByID(box.ID).status = RIGHT_LEFT_CONVEYOR;
				}
			}
			if (playState.getBoxByID(box.ID).status == RIGHT_LEFT_CONVEYOR) {
				if ((box.x + box.width) >= conveyorDoor.door.x && box.x < (conveyorDoor.door.x + conveyorDoor.door.width)) {
					if (((box.x - 1) + box.width) >= conveyorDoor.door.x && box.x < (conveyorDoor.door.x + conveyorDoor.door.width)) {
						conveyorDoor.blocked = true;
					}

					if (conveyorDoor.trueUp) {
						box.velocity.x = GameValues.getConveyorSpeed();
					} else {
						box.velocity.x = 0;
					}
				} else if ((box.x + box.width) > conveyorDoor.door.x + conveyorDoor.door.width) {
					playState.getBoxByID(box.ID).status = RIGHT_LEFT_CONVEYOR_FALLING;
					box.acceleration.y = 100;
					FlxTween.tween(box.velocity, {x: 0}, 2);
				}
			}
			if (playState.getBoxByID(box.ID).status == RIGHT_LEFT_CONVEYOR_FALLING) {
				if (box.y > 320) {
					box.y = 320;
					FlxTween.cancelTweensOf(box.velocity);
					box.velocity.x = GameValues.getConveyorSpeed();
					box.velocity.y = 0;
					box.acceleration.y = 0;
					playState.getBoxByID(box.ID).status = RIGHT_RIGHT_CONVEYOR;
				}
			}
		}
	}

	override function sendBox(id:Int, boxSendType:BoxSendType):Void {
		if (boxSendType == LEFT_BACK_TO_RIGHT) {
			spawnBox(id);
		}
	}

	function spawnBox(id:Int):Void {
		var boxSprite = new FlxSprite(80, -50).makeGraphic(50, 50, 0xFF424242);
		boxSprite.ID = id;
		boxSprite.acceleration.y = 300;
		boxSprites.add(boxSprite);

		playState.getBoxByID(id).status = RIGHT_FALLING;
	}
}
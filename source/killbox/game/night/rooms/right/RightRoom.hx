package killbox.game.night.rooms.right;

class RightRoom extends Room
{
	var bgBack:KbSprite;
	var bgFront:KbSprite;
    
	var boxSprites:FlxSpriteGroup;

	var doorButton:KbSprite;
	var doorButtonPressed:Bool = false;
	
	var conveyorDoor:ConveyorDoor;

	var boxCounter:BoxCounter;

	var confirmationKeypad:ConfirmationKeypad;
	
	var partBox:PartBox;

	var partReceptor:PartReceptor;
	
	var boxVacuum:BoxVacuum;
	
    override function setupRoom():Void{        
		bgBack = new KbSprite().createFromImage('assets/images/night/rooms/right/rightRoomBg.png');
		bgBack.screenCenter();
		add(bgBack);

		conveyorDoor = new ConveyorDoor();
		add(conveyorDoor);

		boxSprites = new FlxSpriteGroup();
		add(boxSprites);

		boxCounter = new BoxCounter(this, boxSprites, 60);
		add(boxCounter);
		
		boxVacuum = new BoxVacuum(this);
		add(boxVacuum);

		partReceptor = new PartReceptor(onSpikeHit);
		add(partReceptor);

		bgFront = new KbSprite().createFromImage('assets/images/night/rooms/right/rightRoomFrontDesk.png');
		bgFront.screenCenter();
		add(bgFront);   
		
		doorButton = new KbSprite(158, 400).createColorBlock(70, 50, 0xFFB5F3CE);
		add(doorButton);

		confirmationKeypad = new ConfirmationKeypad(partReceptor);
		add(confirmationKeypad);
		partBox = new PartBox(partReceptor);
		add(partBox);
		
        possibleMovements = [
            LEFT => 'main'
        ];
    }
	override function update(elapsed:Float):Void {
		super.update(elapsed);

		for (i in [bgBack, conveyorDoor, boxSprites, boxCounter, partReceptor]) {
			i.scrollFactor.set(0.6, 0.6);
		}

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
		manageLeftConveyor();
		manageRightConveyor();
		manageSucking();
	}

	function manageDoorButton():Void {
		if (Cursor.mouseIsTouching(doorButton)) {
			if (FlxG.mouse.pressed && doorButtonPressed || FlxG.mouse.justPressed) {
				doorButtonPressed = true;
				doorButton.color = 0xFF3C915E;

				conveyorDoor.updateDoorStatus(true);
			} else {
				doorButtonPressed = false;
				doorButton.color = 0xFF90C7A6;

				conveyorDoor.updateDoorStatus(false);
			}
		} else {
			doorButton.color = 0xFFB5F3CE;
			doorButtonPressed = false;
			conveyorDoor.updateDoorStatus(false);
		}
	}

	function manageLeftConveyor():Void {
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
					PlayState.tweenManager.tween(box.velocity, {x: 0}, 2);
				}
			}
			if (playState.getBoxByID(box.ID).status == RIGHT_LEFT_CONVEYOR_FALLING) {
				if (box.y > 320) {
					box.y = 320;
					PlayState.tweenManager.cancelTweensOf(box.velocity);
					box.velocity.x = GameValues.getConveyorSpeed();
					box.velocity.y = 0;
					box.acceleration.y = 0;
					playState.getBoxByID(box.ID).status = RIGHT_RIGHT_CONVEYOR;
				}
			}
		}
	}

	function manageRightConveyor():Void {
		for (box in boxSprites) {
			if (playState.getBoxByID(box.ID).status == RIGHT_RIGHT_CONVEYOR) {
				if (box.x > 850) {
					box.velocity.x = 0;
					playState.getBoxByID(box.ID).status = RIGHT_RIGHT_SLIDING;
					PlayState.tweenManager.tween(box, {x: 875}, 1, {
						ease: FlxEase.quartOut,
						onComplete: function(f):Void {
							playState.getBoxByID(box.ID).status = RIGHT_RIGHT_WAITING;
						}
					});
				}
			}
		}
	}
	
	function manageSucking():Void {
		for (box in boxSprites) {
			if (playState.getBoxByID(box.ID).status == RIGHT_RIGHT_SPIKED_CONVEYOR) {
				if (box.x >= FlxG.random.float(1000, 1150)) {
					boxSprites.remove(box, true);
					boxVacuum.boxGroup.add(box);
					playState.getBoxByID(box.ID).status = RIGHT_SUCKING;
					box.velocity.x = 0;
					PlayState.tweenManager.tween(box, {angularVelocity: FlxG.random.float(100, 1000), x: 1200, y: -box.height},
						GameValues.getSuckSpeed() * FlxG.random.float(.8, 1.2), {
							ease: FlxEase.quadInOut,
							onComplete: function(f):Void {
								playState.sendBox(box.ID, RIGHT_TO_TOP);
								boxVacuum.boxGroup.remove(box, true);
								box.destroy();
							}
						});
				}
			}
		}
	}
	
	function onSpikeHit():Void {
		var spikeThese:Array<FlxSprite> = [];

		for (i in boxSprites) {
			for (spike in partReceptor.bottomParts) {
				if (i.overlaps(spike)
					&& (playState.getBoxByID(i.ID).status == RIGHT_RIGHT_CONVEYOR
						|| playState.getBoxByID(i.ID).status == RIGHT_RIGHT_SLIDING
						|| playState.getBoxByID(i.ID).status == RIGHT_RIGHT_WAITING)) {
					spikeThese.push(i);
				}
			}
		}

		var timeLeft = partReceptor.timeLeft;

		var boxesSpiked:Int = 0;

		for (i in spikeThese) {
			if (boxesSpiked >= GameValues.getMaxWorkload()) { // dont do anything
				i.alpha = 0.5;
			} else {
				playState.getBoxByID(i.ID).status = RIGHT_RIGHT_SPIKED;
				i.loadGraphic('assets/images/night/rooms/right/spikedBox.png');
				i.scale.set(1, 1);
				i.velocity.x = 0;
				i.y -= 25;
				i.x = 860;
				PlayState.tweenManager.cancelTweensOf(i.velocity);
				PlayState.tweenManager.cancelTweensOf(i);

				var scaleMult = FlxG.random.float(1.3, 1.6);

				i.scale.set(scaleMult, scaleMult);

				PlayState.tweenManager.tween(i.scale, {x: 1.2, y: 1.2}, timeLeft / 2, {ease: FlxEase.quartOut});
			}

			boxesSpiked++;
		}

		if (spikeThese.length > 0) {
			new FlxTimer(PlayState.timerManager).start(timeLeft / 1.5, function(f):Void {
				for (i in boxSprites) {
					if (i.alpha == .5) {
						i.alpha = 1;
					} else if (playState.getBoxByID(i.ID).status == RIGHT_RIGHT_SPIKED) {
						i.velocity.x = GameValues.getConveyorSpeed();
						playState.getBoxByID(i.ID).status = RIGHT_RIGHT_SPIKED_CONVEYOR;
					}
				}
			});
		}
	}
	
	override function sendBox(id:Int, boxSendType:BoxSendType):Void {
		if (boxSendType == LEFT_BACK_TO_RIGHT) {
			new FlxTimer(PlayState.timerManager).start(GameValues.roomTravelTime(), function(f):Void {
				spawnBox(id);				
			});
		}
	}

	function spawnBox(id:Int):Void {
		var boxSprite = new KbSprite(80, -50).createColorBlock(50, 25, 0xFF424242);
		boxSprite.ID = id;
		boxSprite.acceleration.y = 300;
		boxSprites.add(boxSprite);

		playState.getBoxByID(id).status = RIGHT_FALLING;
	}
	override function leaveRoom():Void {
		if (partBox.partDraggable != null)
			partBox.partDraggable.finish();
	}
}
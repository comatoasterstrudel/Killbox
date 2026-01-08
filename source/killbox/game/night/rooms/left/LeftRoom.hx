package killbox.game.night.rooms.left;

class LeftRoom extends Room
{
	/**
	 * sprites
	 */
	var bgBack:KbSprite;
	var bgFront:KbSprite;
	var bgTube:KbSprite;

	/**
	 * the box press that presses boxes
	 */
	var boxPress:BoxPress;
	
	/**
	 * the pulley that activates the boxPress
	 */
	var chainPulley:ChainPulley;
	
	/**
	 * the spring that sends boxes to the right room
	 */
	var boxSpring:BoxSpring;
	
	/**
	 * front conveyor
	 */
	public var boxFrontConveyorSprites:FlxSpriteGroup;
	var boxCounterFront:BoxCounter;
	
	/**
	 * back conveyor
	 */
	public var boxBackConveyorSprites:FlxSpriteGroup;
	var boxCounterBack:BoxCounter;

	/**
	 * cabinet
	 */
	var bgCabinet:KbSprite;
	var insideCabinet:InsideCabinet;
	var cabinetDoor:CabinetDoor;
	var cabinetButton:KbSprite;
	var cabinetStatus:CabinetStatus = CLOSED;
	
    /**
     * ghosts
     */
	public var erisGhostGroupFront:FlxSpriteGroup;
	public var erisGhostGroupBack:FlxSpriteGroup;

    override function setupRoom():Void{        
		bgBack = new KbSprite().createFromImage('assets/images/night/rooms/left/leftRoomBack.png');
		bgBack.screenCenter();
		bgBack.scrollFactor.set(0, 0);
		add(bgBack);  
        
		boxSpring = new BoxSpring();
		add(boxSpring);
		
		erisGhostGroupBack = new FlxSpriteGroup();
		add(erisGhostGroupBack);
		
		boxBackConveyorSprites = new FlxSpriteGroup();
		add(boxBackConveyorSprites);

		boxCounterBack = new BoxCounter(this, boxBackConveyorSprites, 60);
		add(boxCounterBack);
		
		bgTube = new KbSprite().createFromImage('assets/images/night/rooms/left/leftRoomTube.png');
		bgTube.screenCenter();
		bgTube.scrollFactor.set(0, 0);
		add(bgTube);  
		
		insideCabinet = new InsideCabinet(onCabinetGameFinished);
		add(insideCabinet);

		cabinetDoor = new CabinetDoor();
		add(cabinetDoor);

		bgCabinet = new KbSprite().createFromImage('assets/images/night/rooms/left/leftRoomCabinet.png');
		bgCabinet.screenCenter();
		add(bgCabinet);

		cabinetButton = new KbSprite(480, 495).createColorBlock(100, 25, 0xFF9EBDAF);
		add(cabinetButton);
		
		bgFront = new KbSprite().createFromImage('assets/images/night/rooms/left/leftRoomPlaceholder.png');
		bgFront.screenCenter();
		add(bgFront);  

		erisGhostGroupFront = new FlxSpriteGroup();
		add(erisGhostGroupFront);
		
		boxFrontConveyorSprites = new FlxSpriteGroup();
		add(boxFrontConveyorSprites);
		
		boxCounterFront = new BoxCounter(this, boxFrontConveyorSprites, 100);
		add(boxCounterFront);
		
		boxPress = new BoxPress(pressBoxes);
		add(boxPress);
		
		chainPulley = new ChainPulley(boxPress.startBoxPress);
		add(chainPulley);

		possibleMovements = [ 
            RIGHT => 'main'
        ];
    }
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		for (sprite in [bgBack, boxBackConveyorSprites, boxCounterBack, boxSpring, erisGhostGroupBack]) {
			sprite.scrollFactor.set(0.6, 0.6);
		}
		
		for (sprite in [bgCabinet, cabinetButton, cabinetDoor]) {
			sprite.scrollFactor.set(0.85, 0.85);
		}

		insideCabinet.scrollFactor.set(.82, .82);

		bgTube.scrollFactor.set(.8, .8);
		
		handleFrontConveyor();	
		handleBackConveyor();	
		handleCabinet();
		if (roomActive) {
			#if debug
			if (FlxG.keys.justPressed.ONE) {
				var box = new Box(playState.getBoxID());
				playState.boxes.push(box);
				sendBox(box.ID, MAIN_TO_LEFT);
			}
			if (FlxG.keys.justPressed.TWO) {
				var box = new Box(playState.getBoxID());
				playState.boxes.push(box);
				sendBox(box.ID, LEFT_TO_LEFT_BACK);
			}
			#end
		}
	}

	function pressBoxes():Void
	{
		var boxesPressed:Int = 0;
		
		for (box in boxFrontConveyorSprites)
		{
			if ((box.x + 5) < (boxPress.pressBottom.x + boxPress.pressBottom.width)
				&& (playState.getBoxByID(box.ID).status == LEFT_CONVEYOR
					|| playState.getBoxByID(box.ID).status == LEFT_SLIDING
					|| playState.getBoxByID(box.ID).status == LEFT_WAITING))
			{ // press that shit boy!
				if (boxesPressed >= GameValues.getMaxWorkload()) {
					box.alpha = .5;
				} else {
					box.scale.y = .5;
					box.updateHitbox();
					box.y += box.height;
					PlayState.tweenManager.cancelTweensOf(box);
					PlayState.tweenManager.cancelTweensOf(box.velocity);
					box.x = 150;
					box.velocity.x = 0;
					playState.getBoxByID(box.ID).status = LEFT_PRESSED;
				}
				boxesPressed++;
			}
		}
	}
	
	function handleFrontConveyor():Void{
		for(box in boxFrontConveyorSprites){
			var boxData = playState.getBoxByID(box.ID);

			var removeThese:Array<FlxSprite> = [];
			
			if(boxData.status == LEFT_CONVEYOR){
				if (box.x < 175) {
					box.velocity.x = 0;
					boxData.status = LEFT_SLIDING;
					PlayState.tweenManager.tween(box, {x: 150}, 1, {ease: FlxEase.quartOut, onComplete: function(f):Void{
						boxData.status = LEFT_WAITING;
					}});
				}
			}
			if (boxData.status != LEFT_PRESSED && boxData.status != LEFT_PRESSED_CONVEYOR && boxPress.blockBoxes && box.alpha == 1) // dont let boxes go through the conveyor while its down lol
			{
				if ((box.x) <= (boxPress.pressBottom.x + boxPress.pressBottom.width))
				{
					box.x = boxPress.pressBottom.x + boxPress.pressBottom.width;
				}
			}
			if (boxData.status == LEFT_PRESSED && !boxPress.pressing)
			{
				playState.getBoxByID(box.ID).status = LEFT_PRESSED_CONVEYOR;
				box.velocity.x = -GameValues.getConveyorSpeed();
			}
			if (boxData.status == LEFT_PRESSED_CONVEYOR && ((box.x + box.width) < 0))
			{
				box.velocity.x = 0;
				playState.sendBox(box.ID, LEFT_TO_LEFT_BACK);
				box.kill();
				removeThese.push(box);
			}

			if (box.alpha == .5 && !chainPulley.pressHandleDown && !chainPulley.pressHandleWindingBack) {
				box.alpha = 1;
			}
			
			for (i in removeThese)
			{
				boxFrontConveyorSprites.remove(i, true);
				i.destroy();
			}
		}	
	}

	function handleBackConveyor():Void {
		for (box in boxBackConveyorSprites) {
			var boxData = playState.getBoxByID(box.ID);

			var removeThese:Array<FlxSprite> = [];

			if (boxData.status == LEFT_BACK_CONVEYOR) {
				if (box.x > 750) {
					box.velocity.x = 0;
					boxData.status = LEFT_BACK_SLIDING;
					PlayState.tweenManager.tween(box, {x: 775}, 1, { ease: FlxEase.quartOut, onComplete: function(f):Void {
						boxData.status = LEFT_BACK_WAITING;
					}});
				}
			} else if (boxData.status == LEFT_BACK_SPRINGING_BACKWARDS) {
				if (box.y > 220) {
					box.y = 220;
					PlayState.tweenManager.cancelTweensOf(box);
					box.velocity.y = 0;
					box.velocity.x = GameValues.getConveyorSpeed();
					boxData.status = LEFT_BACK_CONVEYOR;
					box.angularAcceleration = 0;
					box.angularVelocity = 0;
					box.angle = 0;
				}
			}

			for (i in removeThese) {
				boxBackConveyorSprites.remove(i, true);
				i.destroy();
			}
		}	
	}
	function handleCabinet():Void {
		if (Cursor.mouseIsTouching(cabinetButton) && PlayState.curRoom == 'left') {
			switch (cabinetStatus) {
				case CLOSED | PLAYING:
					cabinetButton.color = 0xFF7A9A8B;
				case RECHARGING:
					cabinetButton.color = 0xFF283C33;
				default:
					cabinetButton.color = 0xFFD1F5E4;
			}

			if (FlxG.mouse.justPressed) {
				if (cabinetStatus == CLOSED) {
					cabinetStatus = OPENING;
					insideCabinet.prepGame();
					cabinetDoor.openDoor();

					new FlxTimer(PlayState.timerManager).start(GameValues.getCabinetDoorOpenTime() / 2, function(F):Void {
						cabinetStatus = PLAYING;
						insideCabinet.startGame();
					});
				} else if (cabinetStatus == PLAYING) {
					insideCabinet.submitAttempt();
				}
			}
		} else {
			switch (cabinetStatus) {
				case RECHARGING:
					cabinetButton.color = 0xFF283C33;
				default:
					cabinetButton.color = 0xFFD1F5E4;
			}
		}
	}

	function onCabinetGameFinished(result:InsideCabinetStatus):Void {
		cabinetDoor.closeDoor();

		var springThese:Array<FlxSprite> = [];

		for (box in boxBackConveyorSprites) {
			if ((box.x + 5) > (boxSpring.springTop.x)
				&& (playState.getBoxByID(box.ID).status == LEFT_BACK_CONVEYOR
					|| playState.getBoxByID(box.ID).status == LEFT_BACK_SLIDING
					|| playState.getBoxByID(box.ID).status == LEFT_BACK_WAITING)) { // fling that shit boy!
				springThese.push(box);
				PlayState.tweenManager.cancelTweensOf(box);
				PlayState.tweenManager.cancelTweensOf(box.velocity);
			}
		}

		if (result == LOSS) {
			var boxesFlung:Int = 0;

			for (box in springThese) {
				if (boxesFlung >= GameValues.getMaxWorkload()) {
					box.alpha = .5;
				} else {
					playState.getBoxByID(box.ID).status = LEFT_BACK_SPRINGING_BACKWARDS;
					box.velocity.y = FlxG.random.float(-200, -260);
					box.velocity.x = FlxG.random.float(-100, -200);
					box.angularAcceleration = FlxG.random.float(-300, -10);
					PlayState.tweenManager.tween(box.velocity, {y: 200}, FlxG.random.float(2, 4));	
				}

				boxesFlung++;
			}
		} else if (result == WIN) {
			var boxesFlung:Int = 0;

			for (box in springThese) {
				if (boxesFlung >= GameValues.getMaxWorkload()) {
					box.alpha = .5;
				} else {
					playState.getBoxByID(box.ID).status = LEFT_BACK_SPRINGING_CORRECT;
					PlayState.tweenManager.tween(box, {y: -box.height, angularVelocity: FlxG.random.float(-200, 200)}, FlxG.random.float(.4, .7), {
						ease: FlxEase.quartOut,
						onComplete: function(f):Void {
							playState.sendBox(box.ID, LEFT_BACK_TO_RIGHT);
							boxBackConveyorSprites.remove(box, true);
							box.destroy();
						}
					});
				}

				boxesFlung++;
			}
		}
		boxSpring.springUp();
		cabinetStatus = RECHARGING;
		new FlxTimer(PlayState.timerManager).start(GameValues.getSpringTime(), function(f):Void {
			cabinetStatus = CLOSED;
			for (box in springThese) {
				if (box.alpha == .5)
					box.alpha = 1;
			}
		});
	}

	override function sendBox(id:Int, boxSendType:BoxSendType):Void
	{
		if (boxSendType == MAIN_TO_LEFT)
		{
			new FlxTimer(PlayState.timerManager).start(GameValues.roomTravelTime(), function(f):Void {
				addBoxToFront(id);
			});
		}
		if (boxSendType == LEFT_TO_LEFT_BACK) {
			new FlxTimer(PlayState.timerManager).start(GameValues.roomTravelTime(), function(f):Void {
				addBoxToBack(id);
			});
		}
	}

	function addBoxToFront(id:Int):Void{
		var box = new KbSprite(FlxG.width, 270).createColorBlock(100, 100, 0xFF424242);
		box.ID = id;
		box.velocity.x = -GameValues.getConveyorSpeed();
		boxFrontConveyorSprites.add(box);

		playState.getBoxByID(id).status = LEFT_CONVEYOR;
	}
	
	function addBoxToBack(id:Int):Void {
		var box = new KbSprite(-100, 220).createColorBlock(50, 25, 0xFF323232);
		box.ID = id;
		box.velocity.x = GameValues.getConveyorSpeed();
		boxBackConveyorSprites.add(box);

		playState.getBoxByID(id).status = LEFT_BACK_CONVEYOR;
	}
} 
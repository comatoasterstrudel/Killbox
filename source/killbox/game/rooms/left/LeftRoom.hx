package killbox.game.rooms.left;

class LeftRoom extends Room
{
	var bgBack:FlxSprite;
	var bgFront:FlxSprite;
    
	var boxPress:BoxPress;
	
	var chainPulley:ChainPulley;
	
	var boxFrontConveyorSprites:FlxSpriteGroup;
	var boxBackConveyorSprites:FlxSpriteGroup;

	var boxCounterBack:BoxCounter;
	var boxCounterFront:BoxCounter;
	
    override function setupRoom():Void{        
		bgBack = new FlxSprite().loadGraphic('assets/images/night/roomLeft/leftRoomBack.png');
		bgBack.screenCenter();
		bgBack.scrollFactor.set(0, 0);
		add(bgBack);  
        
		boxBackConveyorSprites = new FlxSpriteGroup();
		add(boxBackConveyorSprites);

		boxCounterBack = new BoxCounter(this, boxBackConveyorSprites, 50);
		add(boxCounterBack);
		
		bgFront = new FlxSprite().loadGraphic('assets/images/night/roomLeft/leftRoomPlaceholder.png');
		bgFront.screenCenter();
		add(bgFront);  

		boxFrontConveyorSprites = new FlxSpriteGroup();
		add(boxFrontConveyorSprites);
		
		boxCounterFront = new BoxCounter(this, boxFrontConveyorSprites);
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

		bgBack.scrollFactor.set(0.65, 0.65);
		boxBackConveyorSprites.scrollFactor.set(.65, .65);
		boxCounterBack.scrollFactor.set(.65, .65);
		handleFrontConveyor();	
		handleBackConveyor();	
	}

	function pressBoxes():Void
	{
		for (box in boxFrontConveyorSprites)
		{
			if ((box.x + 5) < (boxPress.pressBottom.x + boxPress.pressBottom.width)
				&& (playState.getBoxByID(box.ID).status == LEFT_CONVEYOR
					|| playState.getBoxByID(box.ID).status == LEFT_SLIDING
					|| playState.getBoxByID(box.ID).status == LEFT_WAITING))
			{ // press that shit boy!
				box.scale.y = .5;
				box.updateHitbox();
				box.y += box.height;
				FlxTween.cancelTweensOf(box);
				box.x = 150;
				box.velocity.x = 0;
				playState.getBoxByID(box.ID).status = LEFT_PRESSED;
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
					FlxTween.tween(box, {x: 150}, 1, {ease: FlxEase.quartOut, onComplete: function(f):Void{
						boxData.status = LEFT_WAITING;
					}});
				}
			}
			if (boxData.status != LEFT_PRESSED
				&& boxData.status != LEFT_PRESSED_CONVEYOR
				&& boxPress.blockBoxes) // dont let boxes go through the conveyor while its down lol
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
					boxData.status = LEFT_SLIDING;
					FlxTween.tween(box, {x: 775}, 1, {
						ease: FlxEase.quartOut,
						onComplete: function(f):Void {
							boxData.status = LEFT_BACK_WAITING;
						}
					});
				}
			}

			for (i in removeThese) {
				boxBackConveyorSprites.remove(i, true);
				i.destroy();
			}
		}	
	}

	override function sendBox(id:Int, boxSendType:BoxSendType):Void
	{
		if (boxSendType == MAIN_TO_LEFT)
		{
			addBoxToFront(id);
		}
		if (boxSendType == LEFT_TO_LEFT_BACK) {
			addBoxToBack(id);
		}
	}

	function addBoxToFront(id:Int):Void
	{
		var box = new FlxSprite(FlxG.width, 270).makeGraphic(100, 100, 0xFF424242);
		box.ID = id;
		box.velocity.x = -GameValues.getConveyorSpeed();
		boxFrontConveyorSprites.add(box);

		playState.getBoxByID(id).status = LEFT_CONVEYOR;
	}
	function addBoxToBack(id:Int):Void {
		var box = new FlxSprite(-100, 220).makeGraphic(50, 25, 0xFF323232);
		box.ID = id;
		box.velocity.x = GameValues.getConveyorSpeed();
		boxBackConveyorSprites.add(box);

		playState.getBoxByID(id).status = LEFT_BACK_CONVEYOR;
	}
} 
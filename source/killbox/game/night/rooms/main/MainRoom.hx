package killbox.game.night.rooms.main;

class MainRoom extends Room
{
	var bgBack:KbSprite;
	public var boxSprites:FlxSpriteGroup;
	var bgFront:KbSprite;

	var addBoxButton:KbSprite;
	
	var boxCounter:BoxCounter;
	
	var materialMeter:MaterialMeter;

	public var flashlightHolder:FlashlightHolder;
	
	/**
     * ghosts
     */
	public var erisGhostGroup:FlxSpriteGroup;
	
	override function setupRoom():Void
	{     
		bgBack = new KbSprite().createFromImage('assets/images/night/rooms/main/mainRoomPlaceholderBack.png');
		bgBack.screenCenter();
		bgBack.scrollFactor.set(0, 0);
		add(bgBack);  
        
		erisGhostGroup = new FlxSpriteGroup();
		add(erisGhostGroup);
		
		boxSprites = new FlxSpriteGroup();
		add(boxSprites);
		
		boxCounter = new BoxCounter(this, boxSprites, 80);
		add(boxCounter);
		
		bgFront = new KbSprite().createFromImage('assets/images/night/rooms/main/mainRoomPlaceholder.png');
		bgFront.screenCenter();
		add(bgFront);  

		addBoxButton = new KbSprite(270, 295).createColorBlock(100, 30, FlxColor.WHITE);
		add(addBoxButton);
		
		materialMeter = new MaterialMeter(addBoxButton);
		add(materialMeter);
		flashlightHolder = new FlashlightHolder();
		add(flashlightHolder);

        possibleMovements = [
            LEFT => 'left',
			UP => 'top',
            RIGHT => 'right',
        ];
    }
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		for (sprite in [bgBack, boxSprites, boxCounter, erisGhostGroup]) {
			sprite.scrollFactor.set(0.6, 0.6);
		}
		
		handleBoxButton();
		handleBoxPhysics();
		materialMeter.updateMaterialMeter(playState.availableMaterials, playState.timeUntilNextMaterial);
	}

	function handleBoxButton():Void
	{
		if (Cursor.mouseIsTouching(addBoxButton))
		{
			addBoxButton.color = FlxColor.GRAY;
			if (FlxG.mouse.justPressed)
			{
				if (playState.availableMaterials >= 1)
				{
					addBox();		
					playState.availableMaterials--;
				} else
				{
					//
				}
			}
		}
		else
		{
			addBoxButton.color = FlxColor.WHITE;
		}
	}

	function handleBoxPhysics():Void
	{
		var removeThese:Array<FlxSprite> = [];

		for (box in boxSprites.members)
		{
			var boxData = playState.getBoxByID(box.ID);

			if (boxData.status == MAIN_FALLING)
			{
				if (box.y > 180)
				{
					playState.getBoxByID(box.ID).status = MAIN_CONVEYOR;
					box.y = 180;
					box.acceleration.y = 0;
					box.velocity.y = 0;
					box.velocity.x = -GameValues.getConveyorSpeed();
				}
			}
			else if (boxData.status == MAIN_CONVEYOR && box.x < 100)
			{
				box.velocity.x = 0;
				playState.sendBox(box.ID, MAIN_TO_LEFT);
				box.kill();
				removeThese.push(box);
			}
		}

		for (i in removeThese)
		{
			boxSprites.remove(i, true);
			i.destroy();
		}
	}

	function addBox():Void
	{
		var box = new Box(playState.getBoxID());
		playState.boxes.push(box);

		var boxSprite = new KbSprite(400, 0).createColorBlock(50, 50, 0xFF424242);
		boxSprite.ID = box.ID;
		boxSprite.acceleration.y = 300;
		boxSprites.add(boxSprite);
	}
}
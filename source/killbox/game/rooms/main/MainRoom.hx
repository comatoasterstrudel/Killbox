package killbox.game.rooms.main;

class MainRoom extends Room
{
	var bgBack:FlxSprite;
	var boxSprites:FlxSpriteGroup;
	var bgFront:FlxSprite;

	var addBoxButton:FlxSprite;
	
	var boxCounter:BoxCounter;
	
	var materialMeter:MaterialMeter;

	override function setupRoom():Void
	{     
		bgBack = new FlxSprite().loadGraphic('assets/images/night/roomMain/mainRoomPlaceholderBack.png');
		bgBack.screenCenter();
		bgBack.scrollFactor.set(0, 0);
		add(bgBack);  
        
		boxSprites = new FlxSpriteGroup();
		add(boxSprites);
		
		bgFront = new FlxSprite().loadGraphic('assets/images/night/roomMain/mainRoomPlaceholder.png');
		bgFront.screenCenter();
		add(bgFront);  

		addBoxButton = new FlxSprite(240, 290).makeGraphic(100, 30, FlxColor.WHITE);
		add(addBoxButton);
		
		materialMeter = new MaterialMeter();
		add(materialMeter);
		
		boxCounter = new BoxCounter(this, boxSprites);
		boxCounter.camera = playState.camUI;
		add(boxCounter);
		
        possibleMovements = [
            LEFT => 'left',
            UP => 'ceiling',
            RIGHT => 'right',
        ];
    }
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		bgBack.scrollFactor.set(0.6, 0.6);
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

		var boxSprite = new FlxSprite(400, 0).makeGraphic(50, 50, 0xFF424242);
		boxSprite.ID = box.ID;
		boxSprite.acceleration.y = 300;
		boxSprites.add(boxSprite);
	}
}
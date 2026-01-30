package killbox.game.night.rooms.main;

class MainRoom extends Room
{
	var doorLeft:RoomDoor;
	var doorTop:RoomDoor;
	var doorRight:RoomDoor;
	
	var bgBack:KbSprite;
	var bgDetails:KbSprite;
	
	var bgUnderbeltBack:KbSprite;
	var bgConveyorBack:FlxBackdrop;
	var bgPipeBack:KbSprite;
	
	var bgUnderbeltFront:KbSprite;
	var bgConveyorFront:FlxBackdrop;
	var bgPipeFront:KbSprite;
	
	var posterLeft:KbSprite;
	var posterTop:KbSprite;
	var posterRight:KbSprite;
	
	var clock:Clock;
	
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
		bgBack = new KbSprite().createFromImage('assets/images/night/rooms/main/main_back_bg.png');
		bgBack.screenCenter();
		add(bgBack);  
        
		bgDetails = new KbSprite().createFromImage('assets/images/night/rooms/main/main_back_details.png');
		bgDetails.screenCenter();
		add(bgDetails);
		
		bgUnderbeltBack = new KbSprite(0, -22).createFromImage('assets/images/night/rooms/main/main_back_underbelt.png');
		add(bgUnderbeltBack);
		
		bgConveyorBack = new FlxBackdrop('assets/images/night/rooms/main/main_back_conveyor.png', X);
		bgConveyorBack.y = 270;
		bgConveyorBack.velocity.x = GameValues.getConveyorSpeed();
		add(bgConveyorBack);
		
		bgPipeBack = new KbSprite(50).createFromImage('assets/images/night/rooms/main/main_back_pipe_2.png');
		add(bgPipeBack);
		
		var coverup = new KbSprite(245, 100).createColorBlock(420, 330, FlxColor.BLACK);
		coverup.alpha = .5;
		add(coverup);
		
		bgUnderbeltFront = new KbSprite(0, 10).createFromImage('assets/images/night/rooms/main/main_back_underbelt.png');
		add(bgUnderbeltFront);
		
		bgConveyorFront = new FlxBackdrop('assets/images/night/rooms/main/main_back_conveyor.png', X);
		bgConveyorFront.y = 300;
		bgConveyorFront.velocity.x = -GameValues.getConveyorSpeed();
		add(bgConveyorFront);
		
		erisGhostGroup = new FlxSpriteGroup();
		add(erisGhostGroup);
		
		boxSprites = new FlxSpriteGroup();
		add(boxSprites);
		
		bgPipeFront = new KbSprite(0, -30).createFromImage('assets/images/night/rooms/main/main_back_pipe_1.png');
		add(bgPipeFront);
		
		boxCounter = new BoxCounter(this, boxSprites, 80);
		add(boxCounter);
		
		doorLeft = new RoomDoor(50, 266, 135, 430);
		add(doorLeft);
		
		doorTop = new RoomDoor(690, 270, 222, 307);
		add(doorTop);
		
		doorRight = new RoomDoor(1145, 242, 135, 478);
		add(doorRight);
		
		bgFront = new KbSprite().createFromImage('assets/images/night/rooms/main/main_bg.png');
		bgFront.screenCenter();
		add(bgFront);  

		clock = new Clock();
		add(clock);
		
		posterLeft = new KbSprite(25, 15).createFromSparrow('assets/images/night/rooms/main/main_poster_left.png', 'assets/images/night/rooms/main/main_poster_left.xml');
		posterLeft.animation.addByIndices('poster', 'L postyer', [FlxG.random.int(0, 0)], '');
		posterLeft.animation.play('poster');
		add(posterLeft);
		
		posterTop = new KbSprite(305, 10).createFromSparrow('assets/images/night/rooms/main/main_poster_top.png', 'assets/images/night/rooms/main/main_poster_top.xml');
		posterTop.animation.addByIndices('poster', 'top poster', [FlxG.random.int(0, 0)], '');
		posterTop.animation.play('poster');
		add(posterTop);
		
		posterRight = new KbSprite(1130, 25).createFromSparrow('assets/images/night/rooms/main/main_poster_right.png', 'assets/images/night/rooms/main/main_poster_right.xml');
		posterRight.animation.addByIndices('poster', 'rposter', [FlxG.random.int(0, 0)], '');
		posterRight.animation.play('poster');
		add(posterRight);
		
		addBoxButton = new KbSprite(330, 369).createFromSparrow('assets/images/night/rooms/main/main_materialbutton.png', 'assets/images/night/rooms/main/main_materialbutton.xml');
		addBoxButton.animation.addByIndices('active', 'addboxbutton', [0], '', 1);
		addBoxButton.animation.addByIndices('inactive', 'addboxbutton', [1], '', 1);
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

		for (sprite in [bgBack, boxSprites, boxCounter, erisGhostGroup, bgConveyorFront, bgUnderbeltFront, bgPipeFront]) {
			sprite.scrollFactor.set(0.6, 0.6);
		}
		for(sprite in [bgConveyorBack, bgUnderbeltBack, bgPipeBack]){
			sprite.scrollFactor.set(0.2, 0.2);
		}
		bgDetails.scrollFactor.set(.1, .1);
		
		handleBoxButton();
		handleBoxPhysics();
		materialMeter.updateMaterialMeter(playState.availableMaterials, playState.timeUntilNextMaterial);
	}

	function handleBoxButton():Void
	{
		if (playState.availableMaterials >= 1){
			addBoxButton.animation.play('active');

			if (Cursor.mouseIsTouching(addBoxButton))
			{
				addBoxButton.color = 0xFFC8C8C8;
				if (FlxG.mouse.justPressed)
				{
					addBox();		
					playState.availableMaterials--;
				}
			}
			else
			{
				addBoxButton.color = FlxColor.WHITE;
			}	
		} else {
			addBoxButton.animation.play('inactive');
			addBoxButton.color = FlxColor.WHITE;
		}
	}

	function handleBoxPhysics():Void
	{
		var removeThese:Array<FlxSprite> = [];

		for (box in boxSprites.members)
		{
			var boxData = playState.getBoxByID(box.ID);

			if (boxData.status == MAIN_FALLING || boxData.status == MAIN_CONVEYOR_ERIS_FALLING)
			{
				if (box.y > Constants.ROOM_MAIN_CONVEYORY)
				{
					playState.getBoxByID(box.ID).status = MAIN_CONVEYOR;
					box.y = Constants.ROOM_MAIN_CONVEYORY;
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
			i = null;
		}
	}

	function addBox():Void
	{
		var box = new Box(playState.getBoxID());
		playState.boxes.push(box);

		var boxSprite = new KbSprite(515, 100).createFromSparrow('assets/images/night/boxsprites/boxparts.png', 'assets/images/night/boxsprites/boxparts.xml');
		boxSprite.animation.addByIndices('box', 'box sprites', [FlxG.random.int(0, 2)], '');
		boxSprite.animation.play('box');
		boxSprite.ID = box.ID;
		boxSprite.acceleration.y = 300;
		boxSprites.add(boxSprite);
	}
}
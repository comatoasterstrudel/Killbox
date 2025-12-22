package killbox.game;

class PlayState extends FlxState
{
	var rooms:Map<String, Room> = [];
	var roomList:Array<String> = [];
	var curRoom:String = '';
	var roomGroup:FlxTypedGroup<Room>;
	
	var movementUI:MovementUI;

	public var camGame:FlxCamera;
	public var camTransition:FlxCamera;
	public var camUI:FlxCamera;
	
	var camTargetX:Float = 0;
	var camTargetY:Float = 0;
	var camFollowType:CamFollowType = MOUSE;
	
	var flashlightActive:Bool = false;
	var flashlightSprite:FlxSprite;
	
	public var boxes:Array<Box> = [];
	public var boxIdAssignment:Int = 0;
	
	// GAME STUFF
	public var availableMaterials:Int = GameValues.getMaxMaterials();
	public var timeUntilNextMaterial:Float = 0;
	
	public var flashlightBattery:Float = GameValues.getMaxFlashlightBattery();
	
	override public function create()
	{		
		#if debug
		FlxG.watch.add(this, "availableMaterials");
		FlxG.watch.add(this, "timeUntilNextMaterial");
		FlxG.watch.add(this, "flashlightBattery");
		#end
		
		camGame = new FlxCamera();
		camGame.bgColor = FlxColor.WHITE;
		camGame.zoom = 1.05;
		FlxG.cameras.add(camGame);

		camTransition = new FlxCamera();
		camTransition.bgColor = 0x00000000;
		FlxG.cameras.add(camTransition, false);

		camUI = new FlxCamera();
		camUI.bgColor = 0x00000000;
		FlxG.cameras.add(camUI, false);
		
		roomGroup = new FlxTypedGroup<Room>();
		add(roomGroup);
		
		addRoom('main');
		addRoom('left');
		addRoom('right');
		addRoom('top');
		
		movementUI = new MovementUI(changeRoom);
		movementUI.camera = camUI;
		add(movementUI);

		curRoom = 'main';
		updateActiveRooms();
		movementUI.updateActiveButtons(rooms.get(curRoom).possibleMovements);

		flashlightSprite = new FlxSprite().loadGraphic('assets/images/night/flashlight.png');
		flashlightSprite.blend = SCREEN;
		flashlightSprite.alpha = .5;
		flashlightSprite.camera = camGame;
		add(flashlightSprite);

		updateFlashlight(FlxG.elapsed);
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		updateCameraPositions(elapsed);

		updateFlashlight(elapsed);
		
		updateMaterialTimer(elapsed);
		
		super.update(elapsed);
	}
	
	function updateMaterialTimer(elapsed:Float):Void
	{
		if (availableMaterials > GameValues.getMaxMaterials())
		{
			availableMaterials = GameValues.getMaxMaterials();
		}
		if (availableMaterials < GameValues.getMaxMaterials())
		{
			timeUntilNextMaterial += elapsed;

			if (timeUntilNextMaterial >= GameValues.getMaterialRefillTime())
			{
				timeUntilNextMaterial = 0;
				availableMaterials++;
			}
		} else
		{
			timeUntilNextMaterial = 0;
		}

		//
	}
	
	function updateFlashlight(elapsed:Float):Void
	{
		var flashlightInCharger:Bool = Reflect.field(Reflect.getProperty(rooms.get('main'), 'flashlightHolder'), 'holdingLight');

		flashlightActive = (FlxG.mouse.pressedRight && (flashlightBattery > 0) && !flashlightInCharger);

		flashlightSprite.visible = flashlightActive;
		flashlightSprite.x = FlxG.mouse.x - flashlightSprite.width / 2;
		flashlightSprite.y = FlxG.mouse.y - flashlightSprite.height / 2;
		if (flashlightActive) {
			flashlightBattery -= elapsed;
			if (flashlightBattery < 0)
				flashlightBattery = 0;
		}

		if (flashlightInCharger) {
			flashlightBattery += elapsed;
			if (flashlightBattery > GameValues.getMaxFlashlightBattery()) {
				flashlightBattery = GameValues.getMaxFlashlightBattery();
			}
		}
	}
	
	function updateCameraPositions(elapsed:Float):Void
	{
		switch (camFollowType)
		{
			case MOUSE:
				camTargetX = -(Constants.CAM_MOVEMENT_SENSITIVITY / 2) + (Constants.CAM_MOVEMENT_SENSITIVITY * (FlxG.mouse.x / FlxG.width));
				camTargetY = -(Constants.CAM_MOVEMENT_SENSITIVITY / 2) + (Constants.CAM_MOVEMENT_SENSITIVITY * (FlxG.mouse.y / FlxG.height));
			case CUSTOM:
				//
		}

		camGame.scroll.x = Utilities.lerpThing(camGame.scroll.x, camTargetX, elapsed, Constants.CAM_MOVEMENT_SPEED);
		camGame.scroll.y = Utilities.lerpThing(camGame.scroll.y, camTargetY, elapsed, Constants.CAM_MOVEMENT_SPEED);
	}

	function snapCameraPosition():Void
	{
		camGame.scroll.x = camTargetX;
		camGame.scroll.y = camTargetY;
	}

	function moveCameraToDirection(curDirection:MovementTypes, snap:Bool = false):Void
	{
		switch (curDirection)
		{
			case LEFT:
				camTargetX = -Constants.CAM_MOVEMENT_SENSITIVITY;
				camTargetY = 0;
			case RIGHT:
				camTargetX = Constants.CAM_MOVEMENT_SENSITIVITY;
				camTargetY = 0;
			case DOWN:
				camTargetY = Constants.CAM_MOVEMENT_SENSITIVITY;
				camTargetX = 0;
			case UP:
				camTargetY = -Constants.CAM_MOVEMENT_SENSITIVITY;
				camTargetX = 0;
		}

		if (snap)
		{
			snapCameraPosition();
		}
	}
	
	function addRoom(name:String):Void{
		if(rooms.exists(name)){
			FlxG.log.error('Room ${name} already exists!!');
			return;
		}
		
		var newRoom = Room.getRoomFromName(name, this);
		roomGroup.add(newRoom);
		
		rooms.set(name, newRoom);
		roomList.push(name);
		
		updateActiveRooms();
	}
	
	function changeRoom(newRoom:String):Void
	{
		var curDirection:MovementTypes = LEFT;

		var room:Room = rooms.get(curRoom);

		for (direction in [MovementTypes.LEFT, MovementTypes.DOWN, MovementTypes.UP, MovementTypes.RIGHT])
		{
			if (room.possibleMovements.exists(direction) && room.possibleMovements.get(direction) == newRoom)
			{
				curDirection = direction;
				break;
			}
		}

		camFollowType = CUSTOM;
		moveCameraToDirection(curDirection);
		
		movementUI.hide();
		var timeToTransition:Float = GameValues.getMovementSpeed();
		doRoomTransitionAnim(timeToTransition, function():Void
		{
			moveCameraToDirection(getOppositeDirection(curDirection), true);
			camFollowType = MOUSE;
			curRoom = newRoom;
			updateActiveRooms();	
			new FlxTimer().start(timeToTransition / 2, function(f):Void
			{
				movementUI.updateActiveButtons(rooms.get(curRoom).possibleMovements);
			});
		});
	}

	function doRoomTransitionAnim(time:Float, after:Void->Void):Void
	{
		var tranSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		tranSprite.camera = camTransition;
		tranSprite.alpha = 0;
		add(tranSprite);

		FlxTween.tween(tranSprite, {alpha: 1}, time / 2, {
			onComplete: function(f):Void
			{
				after();
				FlxTween.tween(tranSprite, {alpha: 0}, time / 2, {
					onComplete: function(f):Void
					{
						tranSprite.destroy();
					}
				});
			}
		});
	}
	
	function updateActiveRooms():Void{
		for(i in roomList){
			if(i == curRoom){
				rooms.get(i).roomActive = true;
			} else {
				rooms.get(i).roomActive = false;
			}
			rooms.get(i).toggleRoomVisibility();
		}
	}
	function getOppositeDirection(movementType:MovementTypes):MovementTypes
	{
		switch (movementType)
		{
			case LEFT:
				return RIGHT;
			case RIGHT:
				return LEFT;
			case UP:
				return DOWN;
			case DOWN:
				return UP;
		}
	}
	public function getBoxID():Int
	{
		boxIdAssignment++;
		return boxIdAssignment;
	}

	public function getBoxByID(id:Int):Box
	{
		for (i in boxes)
		{
			if (i.ID == id)
				return (i);
		}
		return null;
	}

	public function sendBox(id:Int, boxSendType:BoxSendType):Void
	{
		for (i in rooms)
		{
			i.sendBox(id, boxSendType);
		}
	}
}

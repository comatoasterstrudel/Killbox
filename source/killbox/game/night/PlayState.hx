package killbox.game.night;

/**
 * the state that holds the night gameplay
 * this is the main state you'll be in for the game!!
 */
class PlayState extends FlxState
{
	/**
	 * tween and timer managers
	 */ 
	public static var tweenManager:FlxTweenManager;
	public static var timerManager:FlxTimerManager;

	/**
	 * the game rules for this round
	 */
	public static var GAME_RULES:GameRules;
	
	/**
	 * cameras
	 */
	public var camGame:FlxCamera;
	public var camTransition:FlxCamera;
	public var camUI:FlxCamera;
		
	/**
	 * camera movement
	 */
	var camTargetX:Float = 0;
	var camTargetY:Float = 0;
	var camFollowType:CamFollowType = MOUSE;
	
	/**
	 * rooms
	 */
	public var rooms:Map<String, Room> = [];
	public var roomMain:MainRoom;
	public var roomLeft:LeftRoom;
	public var roomRight:RightRoom;
	public var roomTop:TopRoom;
	var roomList:Array<String> = [];
	public static var curRoom:String = '';
	var roomGroup:FlxTypedGroup<Room>;
	
	/**
	 * ui
	 */
	var movementUI:MovementUI;
	var flashlightChargeBar:FlashlightChargeBar;
	var boxQuotaDisplay:BoxQuotaDisplay;
	
	/**
	 * flashlight
	 */
	public var flashlightBattery:Float = GameValues.getMaxFlashlightBattery();
	public var flashlightActive:Bool = false;
	public var flashlightSprite:KbSprite;

	/**
	 * boxes
	 */
	public var boxes:Array<Box> = [];
	public var boxIdAssignment:Int = 0;
	public var boxesProduced:Int = 0;
	
	/**
	 * materials
	 */
	public var availableMaterials:Int = GameValues.getMaxMaterials();
	public var timeUntilNextMaterial:Float = 0;
	
	/**
	 * ghosts
	 */
	public var ghosts:Array<Ghost> = [];
	
	override public function create()
	{		
		clearManagers();
		
		if (GAME_RULES == null) {
			createGame();
		}
		
		#if debug
		FlxG.watch.add(this, "availableMaterials");
		FlxG.watch.add(this, "timeUntilNextMaterial");
		FlxG.watch.add(this, "flashlightBattery");
		FlxG.watch.add(this, "boxesProduced");
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
		
		addRooms();
		
		movementUI = new MovementUI(changeRoom);
		movementUI.camera = camUI;

		curRoom = 'main';
		updateActiveRooms();
		movementUI.updateActiveButtons(rooms.get(curRoom).possibleMovements);

		flashlightSprite = new KbSprite().createFromImage('assets/images/night/flashlight.png');
		flashlightSprite.blend = SCREEN;
		flashlightSprite.alpha = .5;
		flashlightSprite.camera = camGame;
		add(flashlightSprite);

		flashlightChargeBar = new FlashlightChargeBar();
		flashlightChargeBar.camera = camUI;
		add(flashlightChargeBar);

		boxQuotaDisplay = new BoxQuotaDisplay(boxesProduced, GAME_RULES.boxQuota);
		boxQuotaDisplay.camera = camUI;
		add(boxQuotaDisplay);
		
		add(movementUI);

		updateFlashlight(FlxG.elapsed);
		
		createGhosts();
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		updateCameraPositions(elapsed);

		updateFlashlight(elapsed);
		
		updateMaterialTimer(elapsed);
		
		boxQuotaDisplay.updateDisplay(boxesProduced, GAME_RULES.boxQuota, elapsed);

		updateManagers(elapsed);
		
		managePauseMenu();
		
		updateGhosts(elapsed);
		
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
	}
	
	function updateFlashlight(elapsed:Float):Void
	{
		var flashlightInCharger:Bool = Reflect.field(Reflect.getProperty(rooms.get('main'), 'flashlightHolder'), 'holdingLight');

		flashlightActive = ((FlxG.mouse.pressedRight #if debug || FlxG.keys.pressed.F #end) && (flashlightBattery > 0) && !flashlightInCharger);

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
		flashlightChargeBar.updateBar(flashlightBattery, GameValues.getMaxFlashlightBattery(), elapsed, !flashlightInCharger);
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
	
	function addRooms():Void{
		roomGroup = new FlxTypedGroup<Room>();
		add(roomGroup);
		
		roomMain = new MainRoom(this);
		roomGroup.add(roomMain);
		
		roomLeft = new LeftRoom(this);
		roomGroup.add(roomLeft);
		
		roomRight = new RightRoom(this);
		roomGroup.add(roomRight);
		
		roomTop = new TopRoom(this);
		roomGroup.add(roomTop);
		
		roomList = [
			'main',
			'left',
			'right',
			'top'
		];
		
		rooms = [
			'main'=>roomMain,
			'left'=>roomLeft,
			'right'=>roomRight,
			'top'=>roomTop,

		];
		
		updateActiveRooms();
	}
	
	function changeRoom(newRoom:String):Void
	{
		var curDirection:MovementTypes = LEFT;

		var room:Room = rooms.get(curRoom);

		room.leaveRoom();
		
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
			new FlxTimer(PlayState.timerManager).start(timeToTransition / 2, function(f):Void
			{
				movementUI.updateActiveButtons(rooms.get(curRoom).possibleMovements);
			});
		});
	}

	function doRoomTransitionAnim(time:Float, after:Void->Void):Void
	{
		var tranSprite = new KbSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
		tranSprite.camera = camTransition;
		tranSprite.alpha = 0;
		add(tranSprite);

		tweenManager.tween(tranSprite, {alpha: 1}, time / 2, {
			onComplete: function(f):Void
			{
				after();
				tweenManager.tween(tranSprite, {alpha: 0}, time / 2, {
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
			var previousStatus = rooms.get(i).roomActive;
			
			if(i == curRoom){
				rooms.get(i).roomActive = true;
			} else {
				rooms.get(i).roomActive = false;
			}
			rooms.get(i).toggleRoomVisibility();
			if (rooms.get(i).roomActive && !previousStatus)
				rooms.get(i).enterRoom();
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
	
	function createGhosts():Void{
		ghosts = [];
		
		for(i in GhostUtil.ghostList){
			var ghost = GhostUtil.makeNewGhost(i, this);
			ghosts.push(ghost);
		}
	}
	
	function updateGhosts(elapsed:Float):Void{
		for(i in ghosts){
			i.update(elapsed);
		}
	}
	
	public static function createGame(boxQuota:Int = 3, ?ghostAiList:GhostAiList):GameRules {
		GAME_RULES = {
			boxQuota: boxQuota,
			ghostAiList: ghostAiList ?? new GhostAiList()
		};
		return GAME_RULES;
	}
	
	function managePauseMenu():Void{
		if(FlxG.keys.justPressed.ESCAPE){
			openSubState(new PauseSubState([
				{name: "Resume Game", pressEscape: true, close: true, onClick: function():Void{
					//
				}},
				{name: "Exit Game", pressEscape: false, close: false, onClick: function():Void{
					FlxG.switchState(new CustomGameState());
				}}
			]));
		}
	}
	
	/**
	 * call this to setup the tween and timer managers
	 * theyre specifically defined so they can be paused
	 */
	public static function setUpManagers():Void{
		if(tweenManager == null) tweenManager = new FlxTweenManager();
		if(timerManager == null) timerManager = new FlxTimerManager();
	}
	
	/**
	 * call this to update the tween and timer managers
	 * theyre specifically defined so they can be paused
	 */
	public static function updateManagers(elapsed:Float):Void{
		tweenManager.update(elapsed);
		timerManager.update(elapsed);
	}
	
	/**
	 * call this to update the tween and timer managers
	 * theyre specifically defined so they can be paused
	 */
	public static function clearManagers():Void{
		tweenManager.clear();
		timerManager.clear();
	}
}
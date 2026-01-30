package killbox.util;

class Constants{
	#if debug
	/**
	 * The state to load when loading a debug build of the game
	 */
	public static final INITIAL_STATE_DEBUG:FlxState = new CustomGameState();
	#end

	#if release
	/**
	 * The state to load when loading a release build of the game
	 */
	public static final INITIAL_STATE_RELEASE:FlxState = new CustomGameState();
	#end 
	
	/**
	 * How much the cameras will move along with the mouse
	 */
    public static final CAM_MOVEMENT_SENSITIVITY:Float = 15;
	/**
	 * How fast the cameras will move along with the mouse
	 */
    public static final CAM_MOVEMENT_SPEED:Float = 6;
	/**
	 * The y position of the handle for the chain pulley.
	 */
	public static final CHAIN_PULLEY_BASE_PRESS_HANDLE_POSITION:Float = 100;

	/**
	 * How far the chain on the chain pulley will move down
	 */
	public static final CHAIN_PULLEY_PRESS_DOWN_POSITION_ADDITIVE:Float = 200;
	/**
	 * How long it will take for the flashlight charge bar to disappear
	 */
	public static final FLASHLIGHT_CHARGE_BAR_INACTIVITY_TIME:Float = 0.8;
	/**
	 * How long it will take for the box quota display to disappear
	 */
	public static final BOX_QUOTA_DISPLAY_INACTIVITY_TIME:Float = 2;
	/**
	 * How many digits the box quota text will be able to display
	 */
	public static final BOX_QUOTA_DISPLAY_DIGITS:Int = 5;
	/**
	 * the y value boxes fall to in the main room
	 */
	public static final ROOM_MAIN_CONVEYORY:Float = 275;
}
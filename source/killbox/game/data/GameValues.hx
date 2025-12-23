package killbox.game.data;

class GameValues
{
    public static function getMovementSpeed():Float{
        return 0.6;
    }
    public static function getConveyorSpeed():Float{
        return 100;
    }
    public static function getPressSpeed():Float{
        return 2.5;
    }
	public static function getMaxMaterials():Int
	{
		return 3;
	}
	public static function getMaterialRefillTime():Int
	{
		return 6;
	}
	public static function getMaxFlashlightBattery():Int {
		return 5;
	}
	public static function getCabinetDoorOpenTime():Float {
		return .7;
	}
	public static function getInsideCabinetHitMarkerSpeed():Float {
		return 400;
	}
	public static function getSpringTime():Float {
		return 5;
	}
}
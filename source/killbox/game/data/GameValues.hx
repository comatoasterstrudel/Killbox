package killbox.game.data;

class GameValues
{
	public static function getMaxWorkload():Int {
		return 3;
	}
    public static function getMovementSpeed():Float{
        return 0.6;
    }
    public static function getConveyorSpeed():Float{
        return 100;
    }
	public static function getTubeSpeed():Float {
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
		return .4;
	}
	public static function getInsideCabinetHitMarkerSpeed():Float {
		return 400;
	}
	public static function getSpringTime():Float {
		return 5;
	}
	public static function getComputerSpeed():Int {
		return 1;
	}
	public static function roomTravelTime():Float {
		return 1.5;
	}
	public static function getVerificationCodeLength():Int {
		return 4;
	}
	public static function getMaxSpikePartCount():Int {
		return 3;
	}

	public static function getSpikingTime():Float {
		return 4;
	}

	public static function getSuckSpeed():Float {
		return 2;
	}
}
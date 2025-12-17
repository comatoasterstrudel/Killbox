package;

class Main extends Sprite
{
	public static var cursor:Cursor;
	
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));
		FlxG.mouse.useSystemCursor = true;
		cursor = new Cursor();
		FlxG.plugins.addPlugin(cursor);
		FlxG.plugins.drawOnTop = true;
	}
}

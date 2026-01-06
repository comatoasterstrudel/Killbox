package killbox.game.night.rooms.top.computer;

class ComputerMonitor extends FlxSpriteGroup
{
    var timers:Array<FlxTimer> = [];
    
    var screen:KbSprite;
    
	var flashSprite:KbSprite;

	var textTopLeft:KbText;
	var textTopRight:KbText;

	var curPage:String = '';
	var pages:Array<ComputerPage> = [];

	var interactable:Bool = false;
    
	public var pageMain:ComputerPageMain;
	public var pageFinishProduction:ComputerPageFinishProduction;
	public var pageAcquireCode:ComputerPageAcquireCode;

    public function new():Void{
        super();
        
		screen = new KbSprite(145, 83).createColorBlock(390, 200, FlxColor.LIME);
        add(screen);
		
		textTopLeft = new KbText(screen.x + 10, screen.y + 5, 0, '(c) COMPANY_NAME');
		textTopLeft.setFormat(15, FlxColor.GREEN);
		add(textTopLeft);

		textTopRight = new KbText(screen.x + screen.width - 5, screen.y + 5, 0, '12/24/XX');
		textTopRight.setFormat(15, FlxColor.GREEN);
		textTopRight.x = screen.x + screen.width - textTopRight.width - 10;
		add(textTopRight);

		pageMain = new ComputerPageMain('main', changePage, screen);
		add(pageMain);

		pageFinishProduction = new ComputerPageFinishProduction('finishProduction', changePage, screen);
		add(pageFinishProduction);

		pageAcquireCode = new ComputerPageAcquireCode('acquireCode', changePage, screen);
		add(pageAcquireCode);

		pages = [pageMain, pageFinishProduction, pageAcquireCode];
		
		curPage = 'main';
		updateActivePages();

		flashSprite = new KbSprite(screen.x, screen.y).createColorBlock(Std.int(screen.width), Std.int(screen.height), FlxColor.WHITE);
		flashSprite.alpha = 0;
		add(flashSprite);
	}

	function changePage(name:String):Void {
		curPage = name;
		updateActivePages();

		changeScreenVisibility(false);

		timers.push(new FlxTimer(PlayState.timerManager).start(.2, function(f):Void {
			changeScreenVisibility(true);
		}));
	}

	function updateActivePages():Void {
		for (i in pages) {
			i.pageActive = (i.name == curPage);
		}
    }
    
    public function tranIn():Void{
		PlayState.tweenManager.cancelTweensOf(flashSprite);
		flashSprite.alpha = 0;
		for (i in [textTopLeft, textTopRight]) {
			i.visible = false;
		}
        
        resetTimers();
		changeScreenVisibility(false);

        screen.color = FlxColor.LIME.getDarkened(.8);
        
        for(i in 0...5){
            timers.push(new FlxTimer(PlayState.timerManager).start((.3 - (.1 * (GameValues.getComputerSpeed()))) * i, function(f):Void{
                screen.color = FlxColor.LIME.getDarkened(.8 * (1 - (i / 5)));
				if (i == 4) {
					changeScreenVisibility(true);
					for (i in [textTopLeft, textTopRight]) {
						i.visible = true;
					}
					flashSprite.alpha = FlxG.random.float(.2, .4);
					PlayState.tweenManager.tween(flashSprite, {alpha: 0}, .3);
				}
            }));
        }
    }
    
    public function tranOut():Void{
        resetTimers();
		changeScreenVisibility(false);
		flashSprite.alpha = 0;
		PlayState.tweenManager.cancelTweensOf(flashSprite);
		for (i in [textTopLeft, textTopRight]) {
			i.visible = false;
		}
        screen.color = FlxColor.LIME;

        for(i in 0...3){
            timers.push(new FlxTimer(PlayState.timerManager).start(((GameValues.getMovementSpeed() / 3) / 3) * i, function(f):Void{
                screen.color = FlxColor.LIME.getDarkened(1 * (i / 3));
            }));
        }
    }
    
    function resetTimers():Void{
        for(i in timers){
            if(i != null && i.active) i.cancel();
        }
        
        timers = [];
    }
	function changeScreenVisibility(on:Bool):Void {
		interactable = on;

		for (i in pages) {
			i.visible = (on && i.pageActive);
		}
	}
}
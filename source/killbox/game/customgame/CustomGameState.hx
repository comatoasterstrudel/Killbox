package killbox.game.customgame;

/**
 * the state where you can customize the games stats and make your own level
 */
class CustomGameState extends FlxState
{
    /**
     * sprites
     */
    var topText:KbText;
    var startText:KbText;
    
    /**
    * property panels
    */
    var propertyPanels:Map<String, CustomPropertyPanel> = [];
    var rackCounts:Array<Int> = [0,0,0];

    override function create():Void{
        super.create();
        
        topText = new KbText(0,50, 0, 'Custom Game', 30);
        topText.screenCenter(X);
        add(topText);
        
        startText = new KbText(0,650, 0, 'Start Game', 20);
        startText.screenCenter(X);
        add(startText);
        
        addPanels();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(Cursor.mouseIsTouching(startText)){
            startText.alpha = .3;
            if(FlxG.mouse.justPressed){
                startGame();
            }
        } else {
            startText.alpha = 1;
        }
    }
    
    function addPanels():Void{
        makePanel('Box Quota', 0, 0, 99);
        
        for(i in GhostUtil.ghostList){
            makePanel(i, 1, 0, 20);
        }
    }
    
    function makePanel(label:String, rack:Int = 0, min:Int, max:Int):Void{
        var panel = new CustomPropertyPanel(60 + (200 * rackCounts[rack]), 130 + (160 * rack), label, min, max);
        add(panel);
        
        propertyPanels.set(label, panel);
        
        rackCounts[rack] ++;
    }
    
    function startGame():Void{
        var list:Map<String, Int> = [];
        
        for(i in GhostUtil.ghostList){
            list.set(i, propertyPanels.get(i).value);    
        }
        
        var ghostAiList:GhostAiList = new GhostAiList(list);
        
        PlayState.createGame(propertyPanels.get('Box Quota').value, ghostAiList);
        FlxG.switchState(new PlayState());
    }
}
package killbox.game.night.rooms.left;

class InsideCabinet extends FlxSpriteGroup
{
    var cabinetBack:FlxSprite;
    
    var hitLine:FlxSprite;
    
    var hitTarget:FlxSprite;
    
    var hitMarker:FlxSprite;
    
    var cabinetOverlay:FlxSprite;
    var cabinetResult:FlxSprite;
    
    public var status:InsideCabinetStatus = INACTIVE;
    
    var onCabinetGameFinished:InsideCabinetStatus->Void;
    
    public function new(onCabinetGameFinished:InsideCabinetStatus->Void):Void{
        super();
        
        this.onCabinetGameFinished = onCabinetGameFinished;
        
        cabinetBack = new FlxSprite().loadGraphic('assets/images/night/rooms/left/cabinetBack.png');
        cabinetBack.color = 0xFF070707;
        add(cabinetBack);
        
		hitLine = new FlxSprite(430, 600).makeGraphic(560, 30, FlxColor.GRAY);
        add(hitLine);
        
        hitTarget = new FlxSprite(700, 560).makeGraphic(40, 40, FlxColor.CYAN);
        add(hitTarget);
        
		hitMarker = new FlxSprite().makeGraphic(20, 80, FlxColor.BLUE);
        add(hitMarker);
        
        cabinetOverlay = new FlxSprite().loadGraphic('assets/images/night/rooms/left/cabinetBack.png');
        cabinetOverlay.alpha = 0;
        add(cabinetOverlay);
        
        cabinetResult = new FlxSprite();
        cabinetResult.alpha = 0;
        add(cabinetResult);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(status == PLAYING){
            if(hitMarker.x >= hitLine.x + hitLine.width){
                status = LOSS;
                stopGame();
            }
        }
    }
    
    public function prepGame():Void{
        hitTarget.x = FlxG.random.float(750, 850);
        hitTarget.y = hitLine.y + hitLine.height / 2 - hitTarget.height / 2;
        hitMarker.x = hitLine.x;
        hitMarker.y = hitLine.y + hitLine.height / 2 - hitMarker.height / 2;
        cabinetOverlay.alpha = 0;
        cabinetResult.alpha = 0;
    }
    
    public function startGame():Void{
        status = PLAYING;
        hitMarker.velocity.x = GameValues.getInsideCabinetHitMarkerSpeed();
    }
    
    public function submitAttempt():Void{
        if(status != PLAYING){
            return;
        }
        
        if(FlxG.overlap(hitTarget, hitMarker)){
            status = WIN;
        } else {
            status = LOSS;
        }
        stopGame();
    }
    
    function stopGame():Void{
        hitMarker.velocity.x = 0;
        
        if(status == LOSS){
            cabinetOverlay.color = 0xFF750909;
            cabinetResult.loadGraphic('assets/images/night/rooms/left/cabGame_resultLoss.png');
        } else if(status == WIN){
            cabinetOverlay.color = 0xFF177B50;
            cabinetResult.loadGraphic('assets/images/night/rooms/left/cabGame_resultWin.png');
        }
        
        cabinetResult.setPosition(hitLine.x + hitLine.width / 2 - cabinetResult.width / 2, hitLine.y + hitLine.height / 2 - cabinetResult.height / 2);
        cabinetResult.scale.set(1.2, 1.2);
        
        PlayState.tweenManager.tween(cabinetOverlay, {alpha: .6}, .5, {ease: FlxEase.quartOut});
        PlayState.tweenManager.tween(cabinetResult, {alpha: 1}, .5, {ease: FlxEase.quartOut});
        PlayState.tweenManager.tween(cabinetResult.scale, {x: 1, y: 1}, .5, {ease: FlxEase.quartOut});

		new FlxTimer(PlayState.timerManager).start(1, function(f):Void {
            onCabinetGameFinished(status);
            status = INACTIVE; 
        });
    }    
}
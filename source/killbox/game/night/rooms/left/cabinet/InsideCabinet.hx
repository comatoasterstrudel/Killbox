package killbox.game.night.rooms.left.cabinet;

class InsideCabinet extends FlxSpriteGroup
{
    /**
     * sprite to go behind the cabinet game
     */
    var cabinetBack:KbSprite;
    
    /**
     * the line that the hit target gets placed on
     * and the hit marker slides along
     */
    var hitLine:KbSprite;
    
    /**
     * the target you must hit 
     */
    var hitTarget:KbSprite;
    
    /**
     * the line that shows where youre aiming
     */
    var hitMarker:KbSprite;
    
    /**
     * sprites for the results animation after finishing the cabinet game
     */
    var cabinetOverlay:KbSprite;
    var cabinetResult:KbSprite;
    
    /**
     * the current status of this cabinet
     */
    public var status:InsideCabinetStatus = INACTIVE;
    
    /**
     * function to run after completing the cabinet game
     */
    var onCabinetGameFinished:InsideCabinetStatus->Void;
    
    public function new(onCabinetGameFinished:InsideCabinetStatus->Void):Void{
        super();
        
        this.onCabinetGameFinished = onCabinetGameFinished;
        
        cabinetBack = new KbSprite().createFromImage('assets/images/night/rooms/left/cabinetBack.png');
        cabinetBack.color = 0xFF070707;
        add(cabinetBack);
        
		hitLine = new KbSprite(430, 600).createColorBlock(560, 30, FlxColor.GRAY);
        add(hitLine);
        
        hitTarget = new KbSprite(700, 560).createColorBlock(40, 40, FlxColor.CYAN);
        add(hitTarget);
        
		hitMarker = new KbSprite().createColorBlock(20, 80, FlxColor.BLUE);
        add(hitMarker);
        
        cabinetOverlay = new KbSprite().createFromImage('assets/images/night/rooms/left/cabinetBack.png');
        cabinetOverlay.alpha = 0;
        add(cabinetOverlay);
        
        cabinetResult = new KbSprite();
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
    
    /**
     * call this to initialize the game so that its ready to play
     */
    public function prepGame():Void{
        hitTarget.x = FlxG.random.float(750, 850);
        hitTarget.y = hitLine.y + hitLine.height / 2 - hitTarget.height / 2;
        hitMarker.x = hitLine.x;
        hitMarker.y = hitLine.y + hitLine.height / 2 - hitMarker.height / 2;
        cabinetOverlay.alpha = 0;
        cabinetResult.alpha = 0;
    }
    
    /**
     * call this to start the cabinet game. 
     * make sure to call prepGame()
     */
    public function startGame():Void{
        status = PLAYING;
        hitMarker.velocity.x = GameValues.getInsideCabinetHitMarkerSpeed();
    }
    
    /**
     * call this once you press the button again after starting
     */
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
    
    /**
     * call this to start the ending of the game
     */
    function stopGame():Void{
        hitMarker.velocity.x = 0;
        
        if(status == LOSS){
            cabinetOverlay.color = 0xFF750909;
            cabinetResult.createFromImage('assets/images/night/rooms/left/cabGame_resultLoss.png');
        } else if(status == WIN){
            cabinetOverlay.color = 0xFF177B50;
            cabinetResult.createFromImage('assets/images/night/rooms/left/cabGame_resultWin.png');
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
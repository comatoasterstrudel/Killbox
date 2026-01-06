package killbox.game.night.ghost;

class GhostUtil
{
    public static var ghostList:Array<String> = ['eris', 'rigil', 'toliman', 'sirius', 'gliese', 'makemake'];
    
    public static function makeNewGhost(name:String, playState:PlayState):Ghost{
        switch(name){
            case 'eris':
                return new ErisGhost(playState);
            case 'rigil':
                return new RigilGhost(playState);
            case 'toliman':
                return new TolimanGhost(playState);
            case 'sirius':
                return new SiriusGhost(playState);
            case 'gliese':
                return new GlieseGhost(playState);
            case 'makemake':
                return new MakemakeGhost(playState);
            default: 
                return new Ghost(playState);
        }
    }
}
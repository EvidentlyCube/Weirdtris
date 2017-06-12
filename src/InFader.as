package{
    import flash.display.MovieClip;
    
    public class InFader extends Fader{
        public var spd:Number = 0.005;
        
        public function InFader(gfx:MovieClip, spd:Number = 0.05){
            super(gfx);
            
            this.spd = spd;
            
            gfx.alpha = 0;
        }
        
        override public function kill():void{
            gfx.alpha = 1;
        }
        
        override public function update():void{
            gfx.alpha += spd;
            
            if (gfx.alpha >= 1){
                isFinished = true;
                gfx.alpha = 1;
                Weirdtris.effects.splice(Weirdtris.effects.indexOf(this), 1);
            }
        }
    }
}
package{
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;
    
    public class Blinker extends Fader{
        private var swing:Number = 0;
        
        public function Blinker(gfx:MovieClip){
            super(gfx, null);
        }
        
        override public function kill():void{
            cT.redOffset   = 0;
            cT.greenOffset = 0;
            cT.blueOffset  = 0;
            
            gfx.transform.colorTransform = cT;
        }
        
        public function removeFromList():void{
            var index:uint = Weirdtris.effects.indexOf(this);
            if (index != -1)
                Weirdtris.effects.splice(index, 1);
        }
        
        override public function update():void{
            swing += Math.PI / 60;
            
            cT.redOffset   = Math.sin(swing) * 40;
            cT.greenOffset = Math.sin(swing) * 40;
            cT.blueOffset  = Math.sin(swing) * 40;

            gfx.transform.colorTransform = cT;

            if (swing >= Math.PI){
                isFinished = true;
                cT.redOffset   = 0;
                cT.greenOffset = 0;
                cT.blueOffset  = 0;
                
                gfx.transform.colorTransform = cT;
                
                Weirdtris.effects.splice(Weirdtris.effects.indexOf(this), 1);
            }
        }
    }
}
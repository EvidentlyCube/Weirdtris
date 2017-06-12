package{
    import flash.display.MovieClip;
    
    public class Starer extends Fader{
        
        private var spdX:Number;
        private var spdY:Number
        
        public function Starer(x:Number, y:Number){
            var gfx:MovieClip = new _EFFECT_STAR;
            
            Weirdtris.self.addChild(gfx);
            
            gfx.x = x + Math.random() * 30;
            gfx.y = y + Math.random() * 30;
                
            super(gfx, block);
            
            gfx.alpha += 0.6 + Math.random() * 0.8;
            
            var angle:Number = Math.atan2(gfx.y - y - 15, gfx.x - x - 15);
            var spd:Number = Math.sqrt((gfx.x - x - 15) * (gfx.x - x - 15) + (gfx.y - y - 15) * (gfx.y - y - 15)) / 5; 
            
            spdX = Math.cos(angle) * spd * 2;
            spdY = Math.sin(angle) * spd * 2;
            
            gfx.scaleY = gfx.scaleX = 0.2 + Math.random()*0.8
        }
        
        override public function kill():void{
            gfx.parent.removeChild(gfx);
        }
       
        override public function update():void{
            gfx.x += spdX;
            gfx.y += spdY;
            gfx.rotation += spdX * 4;
            
            spdY += 0.1;
            
            if (Weirdtris.numBlocks == 0 || Block.left == 0){
                gfx.alpha -= 0.05;
            } else {
                gfx.alpha -= 0.005;
            }
            
            
            if (gfx.alpha < 0){
                Weirdtris.effects.splice(Weirdtris.effects.indexOf(this), 1);
                gfx.parent.removeChild(gfx);
                isFinished = true;
            }
        }
    }
}
package com.mauft{
    public class GlobalUtils{
        private static var _stepsFromStart:int = 0;
        
        public static function updateUtils():void{
            _stepsFromStart++;
        }
        
        public static function get stepsFromStart():Number{ return _stepsFromStart; }

    }
}
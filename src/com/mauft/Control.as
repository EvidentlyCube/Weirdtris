package com.mauft{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    public class Control{
        public static const _A                   :int = 65; 
        public static const _B                   :int = 66; 
        public static const _C                   :int = 67; 
        public static const _D                   :int = 68; 
        public static const _E                   :int = 69; 
        public static const _F                   :int = 70; 
        public static const _G                   :int = 71; 
        public static const _H                   :int = 72; 
        public static const _I                   :int = 73; 
        public static const _J                   :int = 74; 
        public static const _K                   :int = 75; 
        public static const _L                   :int = 76; 
        public static const _M                   :int = 77; 
        public static const _N                   :int = 78; 
        public static const _O                   :int = 79; 
        public static const _P                   :int = 80; 
        public static const _Q                   :int = 81; 
        public static const _R                   :int = 82; 
        public static const _S                   :int = 83; 
        public static const _T                   :int = 84; 
        public static const _U                   :int = 85; 
        public static const _V                   :int = 86; 
        public static const _W                   :int = 87;
        public static const _X                   :int = 88; 
        public static const _Y                   :int = 89; 
        public static const _Z                   :int = 90;
        
        public static const _DOWN                :int = 40;
        public static const _LEFT                :int = 37; 
        public static const _RIGHT               :int = 39; 
        public static const _UP                  :int = 38; 
        
        public static const _F1                  :int = 112; 
        public static const _F2                  :int = 113; 
        public static const _F3                  :int = 114; 
        public static const _F4                  :int = 115; 
        public static const _F5                  :int = 116; 
        public static const _F6                  :int = 117; 
        public static const _F7                  :int = 118; 
        public static const _F8                  :int = 119; 
        public static const _F9                  :int = 120; 
        public static const _F10                 :int = 121; 
        public static const _F11                 :int = 122; 
        public static const _F12                 :int = 123;
        public static const _F13                 :int = 124;
        public static const _F14                 :int = 125;
        public static const _F15                 :int = 126; 
        
        public static const _0                   :int = 48;
        public static const _1                   :int = 49;
        public static const _2                   :int = 50;
        public static const _3                   :int = 51;
        public static const _4                   :int = 52;
        public static const _5                   :int = 53;
        public static const _6                   :int = 54;
        public static const _7                   :int = 55;
        public static const _8                   :int = 56;
        public static const _9                   :int = 57;
        
        public static const _BACKSPACE           :int = 8;
        public static const _CAPS_LOCK           :int = 20;
        public static const _CONTROL             :int = 17;
        public static const _DELETE              :int = 46;
        public static const _END                 :int = 35;
        public static const _ENTER               :int = 13;
        public static const _ESCAPE              :int = 27;
        public static const _HOME                :int = 36;
        public static const _INSERT              :int = 45;
        public static const _OPTION              :int = 18;
        public static const _PAGE_DOWN           :int = 34;
        public static const _PAGE_UP             :int = 33;
        public static const _SHIFT               :int = 16;
        public static const _SPACE               :int = 32;
        public static const _TAB                 :int = 9;
        
        public static const _BACKQUOTE           :int = 192;
        public static const _BACKSLASH           :int = 220;
        public static const _COMMA               :int = 188;
        public static const _EQUAL               :int = 187;
        public static const _BRACKET_LEFT        :int = 219;
        public static const _MINUS               :int = 189;
        public static const _PERIOD              :int = 190;
        public static const _APOSTROPHE          :int = 222;
        public static const _BRACKET_RIGHT       :int = 221;
        public static const _SEMICOLON           :int = 186;
        public static const _SLASH               :int = 191;
        
        private static var keyHolds:Array = new Array;
        private static var keyHits :Array = new Array;
        
        private static var _singleHits:Boolean = true;
        
        public function Control(){ new Error("Can't instantiate Control object - please use static methods only!") }
        
        public static function init(stage:Stage):void{
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP,   keyUp);
        }
        
        public static function isKeyDown(keyCode:int):Boolean{
            return keyHolds[keyCode];
        }
        
        public static function isKeyDownSingular(keyCode:int):Boolean{
            var value = keyHolds[keyCode];
			keyHolds[keyCode] = false;
			return value;
        }
        
        public static function isKeyHit(keyCode:int):Boolean{
			return keyHits[keyCode];
        }
        
        public  static function set singleHits(n:Boolean):void   { _singleHits = n;    }
        public  static function get singleHits()         :Boolean{ return _singleHits; }
        
        public  static function resetHits():void{
            keyHits = new Array;
        }
        
        private static function keyDown(e:KeyboardEvent):void{
            keyHolds[e.keyCode] = true;
            keyHits [e.keyCode] = true;
        }
        
        private static function keyUp(e:KeyboardEvent):void{
            keyHolds[e.keyCode] = false;
            keyHits [e.keyCode] = false;
        }
    }
}
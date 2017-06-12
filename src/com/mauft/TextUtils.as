// ActionScript file

package com.mauft{
    
    public class TextUtils{
        public function TextUtils(){ new Error("Can't instantiate TextUtils object - please use static methods only!") }
        
        /**
         * If the <code>string</code>'s length is smaller than <code>length</code>, <code>filler</code> will
         * be added at the string's start to make it as long.
         * <p>Keep in mind that if filler will be a string of more than one characters the resulting
         * string can be bigger than length.
         */
        public static function extendFromLeft(string:String, length:Number, filler:String="0"):String{
            while (string.length < length){
                string = filler + string;
            }
           
            return string;
        }
        
        /**
         * If the <code>string</code>'s length is smaller than <code>length</code>, <code>filler</code> will
         * be added at the string's end to make it as long.
         * <p>Keep in mind that if filler will be a string of more than one characters the resulting
         * string can be bigger than length.
         */
        public static function extendFromRight(string:String, length:Number, filler:String="0"):String{
            while (string.length < length){
                string += filler;
            }
           
            return string;
        }
        
        /**
         * Returns the first occurence of a number in a string.
         */
        public static function numberFromString(string:String):Number{
            var value   :String  = "";
            var dotFound:Boolean = false;
            var charCode:int     = NaN;
            var l       :int     = string.length;
            
            for (var i:int = 0; i < l; i++){
                charCode = string.charCodeAt(i);
                
                if (charCode >= 48 || charCode <= 57){
                    value += String.fromCharCode(charCode);
                    
                } else if (charCode == 46){
                    if (dotFound){
                        break;
                    } else {
                        value    += String.fromCharCode(charCode);
                        dotFound  = true;
                    }
                    
                } else if (value.length > 0){
                    break;
                    
                }
            }
            
            return parseFloat(value);
        }
        
        /**
         * Returns the first occurence of a number in a string as int.
         */
        public static function intFromString(string:String):int{
            var value   :String  = "";
            var charCode:int     = NaN;
            var l       :int     = string.length;
            
            for (var i:int = 0; i < l; i++){
                charCode = string.charCodeAt(i);
                
                if (charCode >= 48 || charCode <= 57){
                    value += String.fromCharCode(charCode);
                    
                } else if (value.length > 0){
                    break;
                    
                }
            }
            
            return parseInt(value);
        }
        
        
    }
}
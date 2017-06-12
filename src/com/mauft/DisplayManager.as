package com.mauft {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import flash.display.DisplayObject;
	import flash.text.TextField;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class DisplayManager {
		public static const GameWidth:int = 600;
		public static const GameHeight:int = 600;
		
		private static var _flashStage:Stage;
		private static var _shadingLayer:Sprite;

		private static var _offsetX:Number = 0;
		private static var _offsetY:Number = 0;

		private static var _scaleX:Number = 1;
		private static var _scaleY:Number = 1;

		private static var _scaleToFit:Boolean = true;

		public static function get scaleToFit():Boolean {
			return _scaleToFit;
		}

		public static function set scaleToFit(value:Boolean):void {
			_scaleToFit = value;
			onStageResize(null);
		}

		private static var _scaleToInteger:Boolean = true;

		public static function get scaleToInteger():Boolean {
			return _scaleToInteger;
		}

		public static function set scaleToInteger(value:Boolean):void {
			_scaleToInteger = value;
			onStageResize(null);
		}

		/**
		 * Shortcut to the instance of the main application
		 */
		private static var _flashApplication:MovieClip;

		public static function get flashApplication():MovieClip {
			return _flashApplication;
		}

		public static function initializeFlash(main:MovieClip, stage:Stage):void {
			_flashStage = stage;
			_flashApplication = main;

			_flashStage.addEventListener(Event.RESIZE, onStageResize);
			_flashApplication.addEventListener(Event.ENTER_FRAME, step);

			_shadingLayer = new Sprite();
			_flashApplication.addChild(_shadingLayer);
		}
		
		private static function step(e:Event):void{
			_flashApplication.setChildIndex(_shadingLayer, _flashApplication.numChildren - 1);
		}

		private static function onStageResize(e:Event):void {
			var hSpacing:Number = 0;
			var vSpacing:Number = 0;

			if (_scaleToFit) {
				var maxScaleX:Number = _flashStage.stageWidth / GameWidth;
				var maxScaleY:Number = _flashStage.stageHeight / GameHeight;

				var maxScale:Number = Math.min(maxScaleX, maxScaleY);
				if (_scaleToInteger) {
					maxScale = Math.floor(maxScale);
				}

				setScale(maxScale, maxScale);

				var newWidth:Number = maxScale * GameWidth;
				var newHeight:Number = maxScale * GameHeight;

				hSpacing = (_flashStage.stageWidth - newWidth) / 2;
				vSpacing = (_flashStage.stageHeight - newHeight) / 2;
			} else {
				_shadingLayer.graphics.clear();
				setScale(1, 1);

				hSpacing = (_flashStage.stageWidth - GameWidth) / 2;
				vSpacing = (_flashStage.stageHeight - GameHeight) / 2;
			}

			setOffset(hSpacing, vSpacing);

			_shadingLayer.graphics.clear();
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(-hSpacing, -vSpacing, _flashStage.stageWidth, vSpacing);
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(-hSpacing, GameHeight, _flashStage.stageWidth, vSpacing);
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(-hSpacing, 0, hSpacing, GameHeight);
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(GameWidth, 0, hSpacing, GameHeight);
			_shadingLayer.graphics.endFill();
		}

		public static function setOffset(x:Number, y:Number):void {
			_offsetX = x;
			_offsetY = y;

			_flashApplication.x = _offsetX;
			_flashApplication.y = _offsetY;
		}

		public static function setScale(scaleX:Number, scaleY:Number):void {
			_scaleX = scaleX;
			_scaleY = scaleY;

			_flashApplication.scaleX = _scaleX;
			_flashApplication.scaleY = _scaleY;
		}


		public static function toggleFullScreen():void {
			if (_flashStage.displayState === StageDisplayState.NORMAL) {
				_flashStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			} else {
				_flashStage.displayState = StageDisplayState.NORMAL;
			}
		}

		public static function setBackgroundColor(color:uint):void {
			_flashApplication.graphics.clear();
			_flashApplication.graphics.beginFill(color);
			_flashApplication.graphics.drawRect(0, 0, GameWidth, GameHeight);
			_flashApplication.graphics.endFill();
		}
	}
}
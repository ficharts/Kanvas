package com.kvs.utils
{
	import flash.display.Sprite;

	/**
	 */	
	public class StageUtil
	{
		/**
		 */		
		public function StageUtil()
		{
		}
		
		/**
		 */		
		public static function initApplication(sprite:Sprite, handler:Function):void
		{
			new App(sprite, handler);
		}
	}
	
}





//------------------------------------
//
//
// 当一个应用中有多个app需要初始化时，必须
// 
// 多核方式处理，不能用静态方法。
//
//
//-------------------------------------


import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;

/**
 */
class App
{
	/**
	 * 为Sprite添加添加至场景时的执行函数。
	 * 
	 * @param $sprite 传入的Sprite实例。
	 * @param $handler 执行函数，执行函数不可包含任何参数。
	 * @param $main 传入的Sprite实例是否为程序主入口Sprite，默认为false。如为true，会针对Stage进行初始化操作。
	 * 
	 */
	public function App($sprite:Sprite, $handler:Function)
	{
		sprite  = $sprite;
		handler = $handler;
		apps.push(this);
		sprite.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, 0, true);
	}
	
	/**
	 * @param evt
	 */		
	private function addToStageHandler(evt:Event):void
	{
		sprite.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		if (stage && (sprite.stage.stageWidth == 0 || sprite.stage.stageHeight == 0))
			sprite.stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
		else
			ready();
		
	}
	
	/**
	 * 解决IE下Flash初始化舞台尺寸无法获取的问题。
	 */		
	private function resizeHandler(evt:Event):void
	{
		if (sprite.stage.stageWidth && sprite.stage.stageHeight)
		{
			sprite.stage.removeEventListener(Event.RESIZE, resizeHandler);
			ready();
		}
	}
	
	/**
	 */		
	private function ready():void
	{
		if (stage)
		{
			stage = false;
			initStage(sprite.stage);
		}
		
		if (handler != null && (handler is Function)) handler();
		
		handler = null;
		sprite  = null;
		apps.splice(apps.indexOf(this), 1);
	}
	
	/**
	 * @param stage
	 */		
	public function initStage(stage:Stage):void
	{
		stage.stageFocusRect = false;
		stage.tabChildren    = false;
		stage.quality        = StageQuality  .BEST;
		stage.scaleMode      = StageScaleMode.NO_SCALE;
		stage.align          = StageAlign    .TOP_LEFT;
	}
	
	
	private static const apps:Array = [];
	
	private static var stage:Boolean = true;
	
	private var handler:Function;
	
	private var sprite:Sprite;
	
}
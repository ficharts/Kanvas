package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	import flash.display.Sprite;
	
	public final class StageUtil extends NoInstance
	{
		public function StageUtil()
		{
			super();
		}
		
		public static function initStage($app:Sprite, $handler:Function, ...$args):void
		{
			new App($app, $handler, $args);
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

final class App
{
	public function App($app:Sprite, $handler:Function, $args:Array)
	{
		app     = $app;
		handler = $handler;
		args    = $args;
		
		check();
	}
	
	private function check():void
	{
		if (app.stage)
		{
			if (stage)
			{
				assignStageWH();
				addEnterFrame();
				addResize();
				addTimer();
			}
			else
			{
				complyHandler();
			}
		}
		else
		{
			app.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		}
	}
	
	private function addEnterFrame():void
	{
		app.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
	}
	
	private function addResize():void
	{
		app.stage.addEventListener(Event.RESIZE, handlerResize);
	}
	
	private function addTimer():void
	{
		timer = new Timer(33);
		timer.addEventListener(TimerEvent.TIMER, handlerTimer);
		timer.start();
	}
	
	private function delEnterFrame():void
	{
		app.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
	}
	
	private function delResize():void
	{
		app.stage.removeEventListener(Event.RESIZE, handlerResize);
	}
	
	private function delTimer():void
	{
		timer.removeEventListener(TimerEvent.TIMER, handlerTimer);
		timer.stop();
		timer = null;
	}
	
	private function assignStageWH():void
	{
		stageWidth  = app.stage.stageWidth;
		stageHeight = app.stage.stageHeight;
	}
	
	private function complyHandler():void
	{
		stage = false;
		if (handler != null) 
			handler.apply(null, args);
		app     = null;
		handler = null;
		args    = null;
	}
	
	private function handlerAddedToStage(e:Event):void
	{
		if (stage)
		{
			assignStageWH();
			addEnterFrame();
			addResize();
			addTimer();
		}
		else
		{
			complyHandler();
		}
	}
	
	private function handlerEnterFrame(e:Event):void
	{
		delEnterFrame();
		delTimer();
		delResize();
		complyHandler();
	}
	
	private function handlerResize(e:Event):void
	{
		if (stageWidth  && 
			stageWidth  == app.stage.stageWidth && 
			stageHeight && 
			stageHeight == app.stage.stageHeight)
		{
			delEnterFrame();
			delResize();
			delTimer();
			complyHandler();
		}
		assignStageWH();
	}
	
	private function handlerTimer(e:TimerEvent):void
	{
		delEnterFrame();
		delTimer();
		delResize();
		complyHandler();
	}
	
	
	
	private static var stage:Boolean = true;
	
	private static var stageWidth:Number;
	
	private static var stageHeight:Number;
	
	private var app    :Sprite;
	
	private var handler:Function;
	
	private var args   :Array;
	
	private var timer  :Timer;
}
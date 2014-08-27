package view.interact
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;

	public class MouseController
	{
		public function MouseController($stage:Stage)
		{
			stage = $stage;
		}
		
		public function get autoHide():Boolean
		{
			return __autoHide;
		}
		
		public function set autoHide(value:Boolean):void
		{
			if (__autoHide!= value)
			{
				__autoHide = value;
				if (autoHide) 
				{
					timer = new Timer(3000, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
					timer.start();
					stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				}
				else
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
					timer = null;
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				}
			}
		}
		private var __autoHide:Boolean;
		
		private function timerComplete(e:TimerEvent):void
		{
			Mouse.hide();
			timer.stop();
		}
		
		private function mouseMove(e:MouseEvent):void
		{
			Mouse.show();
			timer.reset();
			timer.start();
		}
		
		private var stage:Stage;
		private var timer:Timer;
	}
}
package view.interact.keyboard
{
	import consts.ConstsTip;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import view.interact.CoreMediator;
	import view.interact.interactMode.PrevMode;
	import view.ui.Bubble;
	
	/**
	 * 全局键盘控制
	 */
	public class EnableKeyboardSate extends KeyboardStateBase
	{
		public function EnableKeyboardSate(mainMediator:CoreMediator)
		{
			super(mainMediator);
			
			mainMediator.coreApp.addChild(eventCreator);
			eventCreator.visible = false;
			eventCreator.addEventListener(Event.COPY, copyPastHandler, false, 0, true);
			eventCreator.addEventListener(Event.CUT, copyPastHandler, false, 0, true);
			eventCreator.addEventListener(Event.PASTE, copyPastHandler, false, 0, true);
		}
		
		/**
		 */		
		private function copyPastHandler(evt:Event):void
		{
			if (eventCreator.ifWillDo)
			{
				if (evt.type == Event.COPY)
				{
					mainUIMediator.copy();
				}
				else if (evt.type == Event.CUT)
				{
					mainUIMediator.cut();
				}
				else if (evt.type == Event.PASTE)
				{
					mainUIMediator.paste();
				}
				else
				{
					
				}
			}
		}
		
		/**
		 */		
		private var eventCreator:CopyEventCreator = new CopyEventCreator;
		
		/**
		 * 
		 */
		override public function toDisableState():void
		{
			mainUIMediator.isMulitySelectingMode = false;
			mainUIMediator.currentKeyboardState = mainUIMediator.disKeyboardState;
		}
		
		/**
		 * 按键按下
		 */		
		override public function keyDownBoardHandler(evt:flash.events.KeyboardEvent):void
		{
			if (evt.ctrlKey)
			{
				ctrlKey = true;
				
				eventCreator.start();
			}
			
			mainUIMediator.isMulitySelectingMode = (evt.keyCode == 17);
			
			if (evt.shiftKey && ! shiftKey)
			{
				shiftKey = true;
				Bubble.show("智能模式关闭");
				mainUIMediator.autoAlignController.enabled = false;
				mainUIMediator.autofitController.enabled = false;
				mainUIMediator.autoLayerController.enabled = false;
				mainUIMediator.autoGroupController.enabled = false;
				mainUIMediator.zoomMoveControl.zoomScale = 1.05;
			}
			
			if (evt.altKey)
			{
				altKey = true;
			}
		}
		
		private var ctrlKey:Boolean;
		private var shiftKey:Boolean;
		private var altKey:Boolean;
		
		/**
		 * 按键释放
		 */		
		override public function keyUpBoardHandler(evt:KeyboardEvent):void
		{
			if (ctrlKey && ! evt.ctrlKey)
			{
				ctrlKey = false;
				
				eventCreator.end();
			}
			
			mainUIMediator.isMulitySelectingMode = false;
			
			if (shiftKey && ! evt.shiftKey)
			{
				shiftKey = false;
				Bubble.show("智能模式开启");
				mainUIMediator.autoAlignController.enabled = true;
				mainUIMediator.autofitController.enabled = true;
				mainUIMediator.autoLayerController.enabled = true;
				mainUIMediator.autoGroupController.enabled = true;
				mainUIMediator.zoomMoveControl.zoomScale = 1.5;
			}
			
			if (altKey && ! evt.altKey)
			{
				altKey = false;
			}
			
			
			
			switch(evt.keyCode)
			{
				case Keyboard.Z:
					if (evt.ctrlKey)
						mainUIMediator.undo();
					
					break;
				case Keyboard.Y:
					if (evt.ctrlKey)
						mainUIMediator.redo();
				
				case Keyboard.ESCAPE:
					mainUIMediator.esc();
					
					break;
				
				case Keyboard.A:
					
					if (evt.ctrlKey)
						mainUIMediator.selectAll();
					
					break;
				
				case Keyboard.G:
					
					if (evt.ctrlKey)
					{
						if (evt.shiftKey)
							mainUIMediator.unGroup();
						else
							mainUIMediator.group();
					}
						
					break;
				case Keyboard.M:
					mainUIMediator.autoAlignController.enabled = true;
					break;
				
				case Keyboard.DELETE:
					mainUIMediator.del();
					break;
				
				case Keyboard.UP:
					if (mainUIMediator.currentMode is PrevMode)
						mainUIMediator.pageManager.prev();
					else
						mainUIMediator.moveOff(0, (evt.shiftKey) ? -5 : -1);
					break;
				
				case Keyboard.DOWN:
					if (mainUIMediator.currentMode is PrevMode)
						mainUIMediator.pageManager.next();
					else
						mainUIMediator.moveOff(0, (evt.shiftKey) ?  5 :  1);
					break;
				
				case Keyboard.LEFT:
					if (mainUIMediator.currentMode is PrevMode)
						mainUIMediator.pageManager.prev();
					else
						mainUIMediator.moveOff((evt.shiftKey) ? -5 : - 1, 0);
					break;
				
				case Keyboard.RIGHT:
					if (mainUIMediator.currentMode is PrevMode)
						mainUIMediator.pageManager.next();
					else
						mainUIMediator.moveOff((evt.shiftKey) ?  5 :  1, 0);
					break;
				
				case Keyboard.SPACE:
					if (!evt.ctrlKey)
					{
						mainUIMediator.pageManager.reset();
						mainUIMediator.autoZoom();
					}
					
					break;
				case Keyboard.S:
					if (evt.ctrlKey)
					{
						mainUIMediator.coreApp.dispatchEvent(new KVSEvent(KVSEvent.SAVE));
					}
			}
		}
		
		
	}
}
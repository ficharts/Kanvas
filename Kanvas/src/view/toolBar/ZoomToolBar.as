package view.toolBar
{	
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.StageUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import landray.kp.ui.ZoomAuto; ZoomAuto;
	import landray.kp.ui.ZoomIn  ; ZoomIn;
	import landray.kp.ui.ZoomOut ; ZoomOut;
	
	import view.interact.zoomMove.ZoomMoveControl;
	import com.greensock.TweenMax;
	
	/**
	 * 缩放工具栏
	 */
	public final class ZoomToolBar extends Sprite
	{
		public function ZoomToolBar($controller:ZoomMoveControl = null)
		{
			super();
			controller = $controller;
			
			StageUtil.initApplication(this, initialize);
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			addChild(subContainer = new Sprite).alpha = 0;
			
			visible = false;
			
			with (subContainer.graphics) 
			{
				beginFill(0x474946);
				drawRect(0, 0, 36, 100);
				endFill();
			}
			
			zoomAuto = new IconBtn;
			zoomIn   = new IconBtn;
			zoomOut  = new IconBtn;
			
			zoomAuto.styleXML = zoomIn.styleXML = zoomOut.styleXML = btnStyleXML;
			
			zoomAuto.tips = "自适应";
			zoomIn  .tips = "放大";
			zoomOut .tips = "缩小";
			
			zoomAuto.w = zoomAuto.h = 28;
			zoomIn  .w = zoomIn  .h = 28;
			zoomOut .w = zoomOut .h = 28;
			
			zoomAuto.iconW = zoomAuto.iconH = 12;
			zoomIn  .iconW = zoomIn  .iconH = 12;
			zoomOut .iconW = zoomOut .iconH = 12;
			
			zoomAuto.x = zoomIn.x = zoomOut.x = 4;
			
			var pathZoomAuto:String = "landray.kp.ui.ZoomAuto";
			var pathZoomIn  :String = "landray.kp.ui.ZoomIn";
			var pathZoomOut :String = "landray.kp.ui.ZoomOut";
			zoomAuto.setIcons(pathZoomAuto, pathZoomAuto, pathZoomAuto);
			zoomIn  .setIcons(pathZoomIn  , pathZoomIn  , pathZoomIn);
			zoomOut .setIcons(pathZoomOut , pathZoomOut , pathZoomOut);
			
			subContainer.addChild(zoomIn  ).y = 36;
			subContainer.addChild(zoomOut ).y = 68;
			subContainer.addChild(zoomAuto).y = 4 ;
			
			zoomAuto.addEventListener(MouseEvent.CLICK, clickZoomAuto);
			zoomIn  .addEventListener(MouseEvent.CLICK, clickZoomIn);
			zoomOut .addEventListener(MouseEvent.CLICK, clickZoomOut);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
		}
		
		private function timerShowMouseMove(e:MouseEvent):void
		{
			if (mouseX　>=　-　100 && mouseX <= width) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
				timerShowStart();
			} 
		}
		
		private function timerProcessMouseMove(e:MouseEvent):void
		{
			if (mouseX >= - 100 && mouseX <= width)
			{
				timerReset();
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
				timerShowStop();
			}
		}
		
		private function timerHideMouseMove(e:MouseEvent):void
		{
			if (mouseX >= - 100 && mouseX <= width)
			{
				timerHideStop();
			}
			else
			{
				timerHideStart();
			}
		}
		
		private function timerShowComplete(e:TimerEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerHideMouseMove);
			timerShowStop();
			showToolBar();
		}
		
		private function timerHideComplete(e:TimerEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerHideMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
			timerHideStop();
			hideToolBar();
		}
		
		private function timerReset():void
		{
			if (timer)
			{
				timer.reset();
				timer.start();
			}
		}
		
		private function timerShowStart():void
		{
			if (timer == null)
			{
				timer = new Timer(50, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerShowComplete);
				timer.start();
			}
		}
		
		private function timerShowStop():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerShowComplete);
				timer.stop();
				timer = null;
			}
		}
		
		private function timerHideStart():void
		{
			if (timer == null)
			{
				timer = new Timer(1000, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHideComplete);
				timer.start();
			}
		}
		private function timerHideStop():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHideComplete);
				timer.stop();
				timer = null;
			}
		}
		
		private function showToolBar():void
		{
			if(!display) 
			{
				display = true;
				visible = true;
				
				TweenMax.killTweensOf(subContainer, false);
				TweenMax.to(subContainer, .5, {alpha:1});
			}
		}
		
		private function hideToolBar():void
		{
			if( display) 
			{
				display = false;
				
				TweenMax.killTweensOf(subContainer, false);
				TweenMax.to(subContainer, .5, {alpha:0, onComplete:function():void{visible = false}});
			}
		}
		
		/**
		 * @private
		 */
		private function clickZoomIn(e:MouseEvent):void
		{
			if (controller)
				controller.zoomIn(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomOut(e:MouseEvent):void
		{
			if (controller)
				controller.zoomOut(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomAuto(e:MouseEvent):void
		{
			if (controller)
				controller.zoomAuto();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			visible = (alpha<.01) ? true : false;
		}
		
		/**
		 * @private
		 */
		private var zoomIn  :IconBtn;
		
		/**
		 * @private
		 */
		private var zoomOut :IconBtn;
		
		/**
		 * @private
		 */
		private var zoomAuto:IconBtn;
		
		/**
		 * @private
		 */
		public var controller:ZoomMoveControl;
		
		/**
		 * @private
		 */
		private var display:Boolean;
		
		private var subContainer:Sprite;
		
		private var timer:Timer;
		
		private var btnStyleXML:XML = 
			<states>
				<normal radius='0'>
					<fill color='#686A66,#575654' angle="90"/>
					<img/>
				</normal>
				<hover radius='0'>
					<border color='#2D2C2A' alpha='1' thikness='1'/>
					<fill color='#57524F,#4B4643' angle="90"/>
					<img/>
				</hover>
				<down radius='0'>
					<border color='#2D2C2A' alpha='1' thikness='1'/>
					<fill color='#2D2C2A,#262626' angle="90"/>
					<img/>
				</down>
			</states>;
	}
}
package landray.kp.components
{	
	import com.greensock.TweenMax;
	import com.kvs.ui.button.IconBtn;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import landray.kp.core.kp_internal;
	import landray.kp.ui.ZoomAuto;ZoomAuto;
	import landray.kp.ui.ZoomIn  ;ZoomIn;
	import landray.kp.ui.ZoomOut ;ZoomOut;
	import landray.kp.ui.ScreenFull;ScreenFull;
	import landray.kp.ui.ScreenHalf;ScreenHalf;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Viewer;
	
	/**
	 * 缩放工具栏
	 */
	public final class ZoomToolBar extends Sprite
	{
		public function ZoomToolBar($viewer:Viewer)
		{
			super();
			
			viewer = $viewer;
			
			CoreUtil.initApplication(this, initialize);
		}
		
		kp_internal function resetScreenButtons():void
		{
			if (screenHalf && screenFull)
			{
				screenHalf.visible = ! (screenFull.visible = true);
			}
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			with (graphics) 
			{
				beginFill(0x474946);
				drawRect(0, 0, 36, 132);
				endFill();
			}
			
			alpha = 0;
			
			visible = false;
			
			zoomAuto   = new IconBtn;
			zoomIn     = new IconBtn;
			zoomOut    = new IconBtn;
			screenFull = new IconBtn;
			screenHalf = new IconBtn;
			
			zoomAuto  .styleXML = btnStyleXML;
			zoomIn    .styleXML = btnStyleXML;
			zoomOut   .styleXML = btnStyleXML;
			screenFull.styleXML = btnStyleXML;
			screenHalf.styleXML = btnStyleXML;
			
			zoomAuto  .tips = "自适应";
			zoomIn    .tips = "放大";
			zoomOut   .tips = "缩小";
			screenFull.tips = "全屏";
			screenHalf.tips = "退出全屏";
			
			zoomAuto  .w = zoomAuto  .h = 28;
			zoomIn    .w = zoomIn    .h = 28;
			zoomOut   .w = zoomOut   .h = 28;
			screenFull.w = screenFull.h = 28;
			screenHalf.w = screenHalf.h = 28;
			
			zoomAuto  .iconW = 12;
			zoomAuto  .iconH = 11;
			zoomIn    .iconW = 12;
			zoomIn    .iconH = 12;
			zoomOut   .iconW = 12;
			zoomOut   .iconH = 12;
			screenFull.iconW = 18;
			screenFull.iconH = 16;
			screenHalf.iconW = 18;
			screenHalf.iconH = 16;
			
			zoomIn.x = zoomOut.x = zoomAuto.x = screenFull.x = screenHalf.x = 4;
			
			
			var pathZoomAuto  :String = "landray.kp.ui.ZoomAuto";
			var pathZoomIn    :String = "landray.kp.ui.ZoomIn";
			var pathZoomOut   :String = "landray.kp.ui.ZoomOut";
			var pathScreenFull:String = "landray.kp.ui.ScreenFull";
			var pathScreenHalf:String = "landray.kp.ui.ScreenHalf";
			
			zoomAuto  .setIcons(pathZoomAuto  , pathZoomAuto  , pathZoomAuto);
			zoomIn    .setIcons(pathZoomIn    , pathZoomIn    , pathZoomIn);
			zoomOut   .setIcons(pathZoomOut   , pathZoomOut   , pathZoomOut);
			screenFull.setIcons(pathScreenFull, pathScreenFull, pathScreenFull);
			screenHalf.setIcons(pathScreenHalf, pathScreenHalf, pathScreenHalf);
			
			addChild(zoomAuto  ).y = 4;
			addChild(zoomIn    ).y = 36;
			addChild(zoomOut   ).y = 68;
			addChild(screenHalf).y = 100;
			addChild(screenFull).y = 100;
			
			screenHalf.visible = false;
			
			zoomAuto  .addEventListener(MouseEvent.CLICK, clickZoomAuto);
			zoomIn    .addEventListener(MouseEvent.CLICK, clickZoomIn);
			zoomOut   .addEventListener(MouseEvent.CLICK, clickZoomOut);
			screenFull.addEventListener(MouseEvent.CLICK, clickScreenFull);
			screenHalf.addEventListener(MouseEvent.CLICK, clickScreenHalf);
			
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
				TweenMax.killTweensOf(this, false);
				TweenMax.to(this, .5, {alpha:1});
			}
		}
		
		private function hideToolBar():void
		{
			if( display) 
			{
				display = false;
				TweenMax.killTweensOf(this, false);
				TweenMax.to(this, .5, {alpha:0, onComplete:function():void{visible = false}});
			}
		}
		
		/**
		 * @private
		 */
		private function clickZoomIn(e:MouseEvent):void
		{
			viewer.kp_internal::controller.zoomIn(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomOut(e:MouseEvent):void
		{
			viewer.kp_internal::controller.zoomOut(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomAuto(e:MouseEvent):void
		{
			viewer.kp_internal::controller.autoZoom();
		}
		
		/**
		 * @private
		 */
		private function clickScreenHalf(e:MouseEvent):void
		{
			screenHalf.visible = ! (screenFull.visible = true);
			viewer.kp_internal::setScreenState(StageDisplayState.NORMAL);
		}
		
		/**
		 * @private
		 */
		private function clickScreenFull(e:MouseEvent):void
		{
			screenHalf.visible = ! (screenFull.visible = false);
			viewer.kp_internal::setScreenState(StageDisplayState.FULL_SCREEN);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			visible = (alpha) ? true : false;
		}
		
		/**
		 * @private
		 */
		private var zoomIn:IconBtn;
		
		/**
		 * @private
		 */
		private var zoomOut:IconBtn;
		
		/**
		 * @private
		 */
		private var zoomAuto:IconBtn;
		
		/**
		 * @private
		 */
		private var screenFull:IconBtn;
		
		/**
		 * @private
		 */
		private var screenHalf:IconBtn;
		
		/**
		 * @private
		 */
		private var viewer:Viewer;
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var display:Boolean;
		
		private static const btnStyleXML:XML = 
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
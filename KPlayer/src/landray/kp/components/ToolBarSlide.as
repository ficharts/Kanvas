package landray.kp.components
{
	import com.kvs.ui.button.IconBtn;
	
	import flash.display.Sprite;
	
	import landray.kp.core.KPConfig;
	import landray.kp.core.KPEmbeds;
	import landray.kp.core.kp_internal;
	import landray.kp.ui.ScreenFull;ScreenFull;
	import landray.kp.ui.ScreenHalf;ScreenHalf;
	import landray.kp.ui.PageNext  ;PageNext;
	import landray.kp.ui.PagePrev  ;PagePrev;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Viewer;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	import landray.kp.manager.ManagerPage;
	
	public final class ToolBarSlide extends Sprite
	{
		public function ToolBarSlide()
		{
			super();
			CoreUtil.initApplication(this, initialize);
		}
		
		public function updateLayout():void
		{
			visible = (pageManager.length > 0);
			if (visible)
			{
				//background
				drawBackground();
				//buttons
				prev.x = viewer.width * .5 - 102;
				next.x = viewer.width * .5 + 2;
				full.x = half.x = viewer.width - 32;
				
				y = viewer.height - 40;
			}
		}
		
		kp_internal function resetScreenButtons():void
		{
			if (half && full)
				half.visible = ! (full.visible = true);
		}
		
		private function initialize():void
		{
			config = KPConfig.instance;
			embeds = KPEmbeds.instance;
			//background
			drawBackground();
			//buttons
			prev = new IconBtn;
			next = new IconBtn;
			full = new IconBtn;
			half = new IconBtn;
			
			prev.styleXML = next.styleXML = embeds.styleNav;
			full.styleXML = half.styleXML = embeds.styleBtn;
			
			prev.tips = "上一页";
			next.tips = "下一页";
			full.tips = "全屏";
			half.tips = "退出全屏";
			
			prev.w = next.w = 100;
			prev.h = next.h = 28;
			full.w = full.h = half.w = half.h = 28;
			
			prev.iconW = next.iconW = full.iconW = half.iconW = 18;
			prev.iconH = next.iconH = full.iconH = half.iconH = 16;
			
			var pathPrev:String = "landray.kp.ui.PagePrev";
			var pathNext:String = "landray.kp.ui.PageNext";
			var pathFull:String = "landray.kp.ui.ScreenFull";
			var pathHalf:String = "landray.kp.ui.ScreenHalf";
			
			prev.setIcons(pathPrev, pathPrev, pathPrev);
			next.setIcons(pathNext, pathNext, pathNext);
			full.setIcons(pathFull, pathFull, pathFull);
			half.setIcons(pathHalf, pathHalf, pathHalf);
			
			prev.y = next.y = full.y = half.y = 8;
			
			half.visible = false;
			
			addChild(prev);
			addChild(next);
			addChild(full);
			addChild(half);
			
			prev.addEventListener(MouseEvent.CLICK, clickPrev);
			next.addEventListener(MouseEvent.CLICK, clickNext);
			full.addEventListener(MouseEvent.CLICK, clickFull);
			half.addEventListener(MouseEvent.CLICK, clickHalf);
		}
		
		private function drawBackground():void
		{
			with (graphics) 
			{
				clear();
				beginFill(0x474946);
				drawRect(0, 4, viewer.width, 36);
				endFill();
			}
		}
		
		/**
		 * @private
		 */
		private function clickPrev(e:MouseEvent):void
		{
			pageManager.prev();
		}
		/**
		 * @private
		 */
		private function clickNext(e:MouseEvent):void
		{
			pageManager.next();
		}
		/**
		 * @private
		 */
		private function clickHalf(e:MouseEvent):void
		{
			half.visible = !(full.visible = true);
			viewer.screenState = StageDisplayState.NORMAL;
		}
		
		/**
		 * @private
		 */
		private function clickFull(e:MouseEvent):void
		{
			half.visible = !(full.visible = false);
			viewer.screenState = StageDisplayState.FULL_SCREEN;
		}
		
		
		/**
		 * @private
		 */
		private function get viewer():Viewer
		{
			return config.kp_internal::viewer;
		}
		
		private function get pageManager():ManagerPage
		{
			return config.kp_internal::pageManager;
		}
		
		/**
		 * @private
		 */
		private var prev:IconBtn;
		
		/**
		 * @private
		 */
		private var next:IconBtn;
		
		/**
		 * @private
		 */
		private var full:IconBtn;
		
		/**
		 * @private
		 */
		private var half:IconBtn;
		
		/**
		 * @private
		 */
		private var config:KPConfig;
		
		/**
		 * @private
		 */
		private var embeds:KPEmbeds;
	}
}
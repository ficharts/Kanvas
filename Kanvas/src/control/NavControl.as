package control
{
	import com.greensock.TweenLite;
	
	import control.panelState.ChartPanelState;
	import control.panelState.CloseState;
	import control.panelState.PanelState;
	import control.panelState.ShapePanelState;
	import control.panelState.ThemePanelState;
	
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;

	/**
	 * 主程序交互控制器, 
	 * 
	 * 控制图形面板，样式面板，自定义属性面板等的交互动作
	 */	
	public class NavControl
	{
		public function NavControl(main:Kanvas)
		{
			this.app = main;
			
			closeState = new CloseState(this);
			chartState = new ChartPanelState(this);
			shapeState = new ShapePanelState(this);
			themeState = new ThemePanelState(this);
			curPanelState = closeState;
			
			app.addEventListener(InteractEvent.OPEN_SHAPE_PANEL, openShapePanelHandler, false, 0, true);
			app.addEventListener(InteractEvent.OPEN_THEME_PANEL, openThemePanelHandler, false, 0, true);
			app.addEventListener(InteractEvent.OPEN_CHART_PANEL, openChartPanel, false, 0, true);
			
			app.addEventListener(InteractEvent.CLOSE_PANEL, closePanel, false, 0, true);
			
			app.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
			app.addEventListener(InteractEvent.PREVIEW, previewPanelHandler, false, 0, true);
		}
		
		/**
		 */		
		public function toPageEditMode():void
		{
			curPanelState.close();
			app.toolBar.toPageEditMode();
			
			app.zoomToolBar.visible = false;
			app.pagePanel.visible = false;
		}
		
		/**
		 */		
		public function cancelPageEdit():void
		{
			app.kvsCore.cancelPageEdit();
			toNormal();
		}
		
		/**
		 */		
		public function confirmPageEdit():void
		{
			toNormal();
		}
		
		/**
		 * 清除所有页面种的动画效果 
		 * 
		 */		
		public function clearFlashesInPage():void
		{
			app.kvsCore.resetFlashesInPage();
		}
		
		/**
		 * 整体应用进入到正常模式下
		 */		
		public function toNormal():void
		{
			curPanelState.open();
			
			app.kvsCore.toSelect();
			app.toolBar.toNormalMode();
			
			app.zoomToolBar.visible = true;
			app.pagePanel.visible = true;
		}
		
		/**
		 */		
		public function toChartEditMode():void
		{
			curPanelState.close();
			
			app.toolBar.toChartEditMode();
			app.zoomToolBar.visible = false;
		}
		
		/**
		 */		
		private function keyUpHandler(evt:KeyboardEvent):void
		{
			//全屏预览模式, 从F1 ～  F9 任意键按下触发全屏
			if (evt.keyCode >= 112 && evt.keyCode <= 120)
				toPreview();
		}
		
		/**
		 */		
		private function previewPanelHandler(evt:InteractEvent):void
		{
			toPreview();
		}
		
		/**
		 * 进入预览模式
		 */		
		public function toPreview():void
		{
			app.stage.displayState = (CoreApp.isAIR) ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.FULL_SCREEN;
			app.stage.addEventListener(FullScreenEvent.FULL_SCREEN, closeFullScreenHandler);
			
			app.zoomToolBar.y = 10000;
			
			curPanelState.close();
			TweenLite.to(app.pagePanel, 0.5, {x: - app.pagePanel.w - 50/*防止滚动条可见，给的值稍大*/});
			TweenLite.to(app.toolBar, 0.5, {y: - app.toolBar.h});
			
			app.updateKvsContenBound();
			app.kvsCore.toPreview();
		}
		
		/**
		 */		
		private function closeFullScreenHandler(evt:FullScreenEvent):void
		{
			app.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, closeFullScreenHandler);
			
			curPanelState.open();
			TweenLite.to(app.pagePanel, 0.5, {x: 0});
			TweenLite.to(app.toolBar, 0.5, {y: 0});
			app.zoomToolBar.y = (app.stage.stageHeight - app.zoomToolBar.height) * .5;
			
			app.updateKvsContenBound();
			app.kvsCore.returnFromPrev();
		}
		
		/**
		 * 窗口缩放时，将右侧面板重新对齐
		 * 
		 */		
		public function alginToRight():void
		{
			curPanelState.alginToRight();
		}
		
		/**
		 */		
		public function get rightPanelWidth():Number
		{
			return curPanelState.rightPanelWidth;
		}
		
		/**
		 */		
		private function closePanel(evt:InteractEvent):void
		{
			curPanelState.toClose();
		}
		
		
		/**
		 */		
		private function openChartPanel(evt:InteractEvent):void
		{
			curPanelState.toChartPanel();
		}
			
		/**
		 */		
		private function openShapePanelHandler(evt:InteractEvent):void
		{
			curPanelState.toShapePanel();
		}
		
		/**
		 */		
		private function openThemePanelHandler(evt:InteractEvent):void
		{
			curPanelState.toThemePanel();
		}
		
		
		/**
		 */		
		public var curPanelState:PanelState;
		public var closeState:PanelState;
		public var chartState:PanelState;
		public var shapeState:PanelState;
		public var themeState:PanelState;
		
		/**
		 */		
		public var app:Kanvas;
	}
}
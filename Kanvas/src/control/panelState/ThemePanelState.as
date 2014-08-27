package control.panelState
{
	import control.NavControl;

	public class ThemePanelState extends PanelState
	{
		public function ThemePanelState(nav:NavControl)
		{
			super(nav);
		}
		
		
		/**
		 */		
		override public function get rightPanelWidth():Number
		{
			return app.themePanel.w;
		}
		
		/**
		 */		
		override public function alginToRight():void
		{
			app.themePanel.x = app.stage.stageWidth - app.themePanel.w;
			app.chartPanel.x = app.shapePanel.x = app.stage.stageWidth;
			
			app.zoomToolBar.x = app.stage.stageWidth - app.themePanel.w - app.zoomToolBar.width - 20;
		}
		
		/**
		 */		
		override public function toChartPanel():void
		{
			closeThemPanel();
			nav.curPanelState = nav.chartState;
			openTargetPanel(app.toolBar.chartBtn, app.chartPanel);
		}
		
		/**
		 */		
		override public function toShapePanel():void
		{
			closeThemPanel();
			nav.curPanelState = nav.shapeState;
			openTargetPanel(app.toolBar.addBtn, app.shapePanel);
		}
		
		/**
		 */		
		override public function close():void
		{
			closeThemPanel();
		}
		
		/**
		 */		
		override public function open():void
		{
			openTargetPanel(app.toolBar.themeBtn, app.themePanel);
		}
		
		/**
		 */		
		override public function toClose():void
		{
			nav.curPanelState = nav.closeState;
			closeThemPanel();
		}
		
		/**
		 */		
		protected function closeThemPanel():void
		{
			app.toolBar.themeBtn.selected = false;
			app.themePanel.close(app.stage.stageWidth, app.toolBar.h);
			
			this.app.updateKvsContenBound();
			moveZBRight();
		}
	}
}
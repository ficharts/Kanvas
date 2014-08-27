package control.panelState
{
	import control.NavControl;

	/**
	 */	
	public class ChartPanelState extends PanelState
	{
		public function ChartPanelState(nav:NavControl)
		{
			super(nav);
		}
		
		/**
		 */		
		override public function get rightPanelWidth():Number
		{
			return app.chartPanel.w;
		}
		
		/**
		 */		
		override public function toShapePanel():void
		{
			closeChartPanel();
			nav.curPanelState = nav.shapeState;
			openTargetPanel(app.toolBar.addBtn, app.shapePanel);
		}
		
		/**
		 */		
		override public function toThemePanel():void
		{
			closeChartPanel();
			nav.curPanelState = nav.themeState;
			openTargetPanel(app.toolBar.themeBtn, app.themePanel);
		}
		
		/**
		 */		
		override public function close():void
		{
			closeChartPanel();
		}
		
		/**
		 */		
		override public function open():void
		{
			openTargetPanel(app.toolBar.chartBtn, app.chartPanel);
		}
		
		/**
		 */		
		override public function toClose():void
		{
			nav.curPanelState = nav.closeState;
			closeChartPanel();
		}
		
		/**
		 */		
		protected function closeChartPanel():void
		{
			app.toolBar.chartBtn.selected = false;
			app.chartPanel.close(app.stage.stageWidth, app.toolBar.h);
			
			this.app.updateKvsContenBound();
			moveZBRight();
		}
		
		/**
		 */		
		override public function alginToRight():void
		{
			app.chartPanel.x = app.stage.stageWidth - app.chartPanel.w;
			app.shapePanel.x = app.themePanel.x = app.stage.stageWidth;
			
			app.zoomToolBar.x = app.stage.stageWidth - app.chartPanel.w - app.zoomToolBar.width - 20;
		}
	}
}
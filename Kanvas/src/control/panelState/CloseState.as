package control.panelState
{
	import control.NavControl;

	/**
	 */	
	public class CloseState extends PanelState
	{
		public function CloseState(nav:NavControl)
		{
			super(nav);
		}
		
		/**
		 */		
		override public function toChartPanel():void
		{
			nav.curPanelState = nav.chartState;
			openTargetPanel(app.toolBar.chartBtn, app.chartPanel);
		}
		
		/**
		 */		
		override public function toThemePanel():void
		{
			nav.curPanelState = nav.themeState;
			openTargetPanel(app.toolBar.themeBtn, app.themePanel);
		}
		
		/**
		 */		
		override public function toShapePanel():void
		{
			nav.curPanelState = nav.shapeState;
			openTargetPanel(app.toolBar.addBtn, app.shapePanel);
		}
		
		/**
		 */		
		override public function alginToRight():void
		{
			app.chartPanel.x = app.shapePanel.x = app.themePanel.x = app.stage.stageWidth;
			app.zoomToolBar.x = app.stage.stageWidth - app.zoomToolBar.width - 20;
		}
	
		
	}
}
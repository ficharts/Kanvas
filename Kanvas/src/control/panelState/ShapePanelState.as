package control.panelState
{
	import control.NavControl;

	/**
	 */	
	public class ShapePanelState extends PanelState
	{
		public function ShapePanelState(nav:NavControl)
		{
			super(nav);
		}
		
		
		/**
		 */		
		override public function get rightPanelWidth():Number
		{
			return app.shapePanel.w;
		}
		
		/**
		 */		
		override public function alginToRight():void
		{
			app.shapePanel.x = app.stage.stageWidth - app.shapePanel.w;
			app.chartPanel.x = app.themePanel.x = app.stage.stageWidth;
			
			app.zoomToolBar.x = app.stage.stageWidth - app.shapePanel.w - app.zoomToolBar.width - 20;
		}
		
		/**
		 */		
		override public function toChartPanel():void
		{
			closeShapePanel();
			nav.curPanelState = nav.chartState;
			openTargetPanel(app.toolBar.chartBtn, app.chartPanel);
		}
		
		/**
		 */		
		override public function toThemePanel():void
		{
			closeShapePanel();
			nav.curPanelState = nav.themeState;
			openTargetPanel(app.toolBar.themeBtn, app.themePanel);
		}
		
		/**
		 */		
		override public function close():void
		{
			closeShapePanel();
		}
		
		/**
		 */		
		override public function open():void
		{
			openTargetPanel(app.toolBar.addBtn, app.shapePanel);
		}
		
		/**
		 */		
		override public function toClose():void
		{
			nav.curPanelState = nav.closeState;
			closeShapePanel();
		}
		
		/**
		 */		
		protected function closeShapePanel():void
		{
			app.toolBar.addBtn.selected = false;
			app.shapePanel.close(app.stage.stageWidth, app.toolBar.h);
			
			this.app.updateKvsContenBound();
			moveZBRight();
		}
	}
}
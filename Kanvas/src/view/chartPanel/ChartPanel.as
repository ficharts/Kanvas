package view.chartPanel
{
	import com.kvs.ui.Panel;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import control.InteractEvent;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import model.ElementProxy;
	
	import view.ItemSelector;
	import view.shapePanel.ShapeCreateProxy;
	
	/**
	 */	
	public class ChartPanel extends Panel
	{
		public function ChartPanel(mainApp:Kanvas)
		{
			super();
			
			chartsConfig = XML(ByteArray(new ConfigXML).toString());
			
			this.app = mainApp;
			shapeCreateProxy = new ShapeCreateProxy(mainApp, this);
			
			this.app = mainApp;
			
			
			lineChart;
			columnChart;
			barChart;
			bubbleChart;
			pieChart;
			areaChart;
			markerChart;
			stackedBarChart;
			stackedColumnChart;
		}
		
		/**
		 */		
		private var shapeCreateProxy:ShapeCreateProxy;
		
		/**
		 */		
		override public function updateLayout():void
		{
			super.updateLayout();
			
			if (scrollHolder)
			{
				scrollHolder.updateMask();
				scrollHolder.update();
			}
		}
		
		/**
		 */		
		private var chartsConfig:XML;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			exitBtn.addEventListener(MouseEvent.CLICK, exitHandler, false, 0, true);
			
			
			scrollHolder = new ChartScrollProy(this);
			scrollHolder.updateMask();
			scrollHolder.update();
			
			XMLVOLib.resisterClass('shape', ElementProxy);
			XMLVOLib.resisterClass('selector', ItemSelector);
			XMLVOMapper.fuck(chartsConfig, chartPage);
			
			chartPage.y = barHeight;
			chartPage.w = this.w;
			addChild(chartPage);
			
			render();
		}
		
		/**
		 */		
		internal var chartPage:ChartPage = new ChartPage();
		
		/**
		 */		
		private function exitHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new InteractEvent(InteractEvent.CLOSE_PANEL));
		}
		
		/**
		 */		
		private var scrollHolder:ChartScrollProy;
		
		/**
		 */		
		private var app:Kanvas;
		
		[Embed(source="../../chartPage.xml", mimeType="application/octet-stream")]
		public var ConfigXML:Class;
	}
}
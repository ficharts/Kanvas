package view.element.chart
{
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
	import com.kvs.charts.chart2D.encry.CSB;
	import com.kvs.charts.chart2D.encry.ISeries;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.DisplayObject;
	
	import model.vo.ChartVO;
	import model.vo.ElementVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 
	 * 图表组件，包含所有图表
	 * 
	 */	
	public class ChartElement extends ElementBase implements IAutoGroupElement, IChartElement
	{
		public function ChartElement(vo:ElementVO)
		{
			super(vo);
			
			createChart();
			
			addChild(chart);
		}
		
		/**
		 */		
		public function resetFlash():void
		{
			chart.chart.resetFlash();
		}
		
		/**
		 */		
		public function flash():void
		{
			chart.chart.flash();
		}
		
		/**
		 */		
		public function toFlashEnd():void
		{
			chart.chart.toFlashEnd();
		}
		
		/**
		 */		
		protected function createChart():void
		{
			chart = new Chart2D;
		}
		
		/**
		 */		
		public function get series():Vector.<ISeries>
		{
			return chart.chart.series;
		}
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.chart);
		}
		
		/**
		 * 初始化
		 */
		override protected function init():void
		{
			preRender();
			
			if (chart.ifReady)
				render();
			else
				chart.addEventListener(FiChartsEvent.CHART_READY, readyHandler);
		}
		
		/**
		 */		
		private function readyHandler(evt:FiChartsEvent):void
		{
			chart.removeEventListener(FiChartsEvent.CHART_READY, readyHandler);
			
			this.render();
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			chart.width = chartVO.width;
			chart.height = chartVO.height;
			
			//if (chartVO.ifDataChanged)
			//{
				chart.setLib();
				
				chart.setConfigXML(chartVO.config.toString());
				chart.render();
				
				XMLVOLib.unsetLib();
				
				chartVO.ifDataChanged = false;
			//}
				
			chart.x = - chart.width / 2;
			chart.y = - chart.height / 2;
			
			if (ifSizing)
			{
				chart.visible = true;
				ifSizing = false;
				
				_shape.graphics.clear();
			}
		}
		
		/**
		 */		
		public function set configXML(xml:XML):void
		{
			chartVO.config = xml;
		}
		
		/**
		 */		
		public function get configXML():XML
		{
			return XML(chartVO.config.toString());
		}
		
		/**
		 */		
		public function setData(data:Vector.<Object>):void
		{
			chart.chart.dataVOes = data;
		}
		
		/**
		 */		
		override public function resizing():void
		{
			super.render();
			
			if (ifSizing == false)// 刚开始resize
			{
				chart.visible = false;
				ifSizing = true;
			}
				_shape.graphics.clear();
				BitmapUtil.drawBitmapDataToGraphics(BitmapUtil.getBitmapData(chart), _shape.graphics, 
					vo.width, vo.height, - vo.width / 2, - vo.height / 2, true);
				
		}
		
		/**
		 */		
		private var ifSizing:Boolean = false;
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			super.showControlPoints(selector);
			
			ViewUtil.show(selector.sizeControl);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			super.hideControlPoints(selector);
			
			ViewUtil.hide(selector.sizeControl)
		}
		
		/**
		 * 
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			super.hideFrameOnMdown(selector);
			
			ViewUtil.hide(selector.sizeControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			super.showSelectorFrame(selector);
			
			ViewUtil.show(selector.sizeControl);
		}
		
		/**
		 */		
		override public function get graphicShape():DisplayObject
		{
			return chart;
		}
		
		/**
		 */		
		protected var chart:CSB;
		
		/**
		 */		
		private function get chartVO():ChartVO
		{
			return vo as ChartVO;
		}
			
	}
}
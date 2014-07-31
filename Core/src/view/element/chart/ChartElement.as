package view.element.chart
{
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
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
	 */	
	public class ChartElement extends ElementBase implements IAutoGroupElement
	{
		public function ChartElement(vo:ElementVO)
		{
			super(vo);
			
			chart2d = new Chart2D();
			addChild(chart2d);
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
			
			if (chart2d.ifReady)
				render();
			else
				chart2d.addEventListener(FiChartsEvent.CHART_READY, readyHandler);
		}
		
		/**
		 */		
		private function readyHandler(evt:FiChartsEvent):void
		{
			chart2d.removeEventListener(FiChartsEvent.CHART_READY, readyHandler);
			
			this.render();
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			chart2d.setLib();
			
			chart2d.width = chartVO.width;
			chart2d.height = chartVO.height;
			
			chart2d.setConfigXML(chartVO.data.toString());
			chart2d.render();
			
			chart2d.x = - chart2d.width / 2;
			chart2d.y = - chart2d.height / 2;
			
			XMLVOLib.unsetLib();
			
			if (ifSizing)
			{
				
				chart2d.visible = true;
				ifSizing = false;
				
				graphicShape.graphics.clear();
			}
		}
		
		/**
		 */		
		override public function resizing():void
		{
			super.render();
			
			if (ifSizing == false)// 刚开始resize
			{
				
				
				chart2d.visible = false;
				ifSizing = true;
			}
				graphicShape.graphics.clear();
				BitmapUtil.drawBitmapDataToGraphics(BitmapUtil.getBitmapData(chart2d), graphicShape.graphics, 
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
		override public function get shape():DisplayObject
		{
			return chart2d;
		}
		
		/**
		 */		
		private var chart2d:Chart2D;
		
		/**
		 */		
		private function get chartVO():ChartVO
		{
			return vo as ChartVO;
		}
			
	}
}
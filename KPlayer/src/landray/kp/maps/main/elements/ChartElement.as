package landray.kp.maps.main.elements
{
	import com.kvs.charts.chart2D.encry.CSB;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import flash.display.DisplayObject;
	
	import model.vo.ChartVO;
	import model.vo.ElementVO;
	
	import view.element.chart.Chart2D;
	import view.element.chart.IChartElement;
	
	/**
	 */	
	public class ChartElement extends Element implements IChartElement
	{
		public function ChartElement($vo:ElementVO)
		{
			super($vo);
			
			chart = new Chart2D;
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
		override public function render():void
		{
			super.render();
			
			chart.setLib();
			
			chart.width = chartVO.width;
			chart.height = chartVO.height;
			
			chart.setConfigXML(chartVO.config.toString());
			chart.render();
			
			chart.x = - chart.width / 2;
			chart.y = - chart.height / 2;
			
			XMLVOLib.unsetLib();
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
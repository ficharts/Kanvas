package landray.kp.maps.main.elements
{
	import com.kvs.charts.chart2D.encry.CSB;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import model.vo.ChartVO;
	import model.vo.ElementVO;
	
	import view.element.chart.Chart2D;
	
	/**
	 */	
	public class ChartElement extends Element
	{
		public function ChartElement($vo:ElementVO)
		{
			super($vo);
			
			chart = new Chart2D;
			addChild(chart);
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
		protected var chart:CSB;
		
		/**
		 */		
		private function get chartVO():ChartVO
		{
			return vo as ChartVO;
		}
	}
}
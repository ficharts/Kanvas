package view.element.chart
{
	import com.kvs.charts.chart2D.encry.CB;
	import com.kvs.charts.chart2D.encry.CSB;
	
	import model.DecForKvs;
	
	/**
	 * 
	 * @author wanglei
	 * 
	 * 2D 图表
	 * 
	 */	
	public class Chart2D extends CSB
	{
		public function Chart2D()
		{
			super();
		}
		
		/**
		 */
		override protected function createChart():void
		{
			chart = new CB();
			
			super.createChart(); 
		}
		
		/**
		 */		
		override protected function initStyle():void
		{
			initStyleTempalte(DecForKvs.chart2dConfig);
		}
		
		
	}
}
package view.element.chart
{
	import com.kvs.charts.chart2D.encry.CSB;
	import com.kvs.charts.chart2D.encry.PCB;
	
	import model.DecForKvs;
	
	public class Pie2D extends CSB
	{
		public function Pie2D()
		{
			super();
		}
		
		/**
		 */
		override protected function createChart():void
		{
			chart = new PCB()
			
			super.createChart(); 
		}
		
		/**
		 */		
		override protected function initStyle():void
		{
			initStyleTempalte(DecForKvs.pie2dConfig);
		}
	}
}
package view.element.chart
{
	import model.vo.ElementVO;
	
	/**
	 */	
	public class PieElement extends ChartElement implements IChartElement
	{
		public function PieElement(vo:ElementVO)
		{
			super(vo);
		}
		
		/**
		 */		
		override protected function createChart():void
		{
			chart = new Pie2D;
		}
	}
}
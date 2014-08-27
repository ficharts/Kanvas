package view.editor.chart
{
	public class PieSeriesProxy extends SeriesProxy
	{
		public function PieSeriesProxy()
		{
			super();
		}
		
		/**
		 */		
		override public function appendFfix(pre:String, suf:String, confg:XML):void
		{
			confg.@ySuffix = suf;
			confg.@yPrefix = pre;
		}
	}
}
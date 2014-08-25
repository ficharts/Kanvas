package view.editor.chart
{
	import com.kvs.utils.RexUtil;

	public class BubbleSeriesProxy extends SeriesProxy
	{
		public function BubbleSeriesProxy()
		{
			super();
		}
		
		/**
		 */		
		override public function applyData(data:XML, index:uint):void
		{
			data.@[labelField] = labels[index];
			data.@[valueField] = RexUtil.filterNumValue(values[index]);
			data.@["z"] = RexUtil.filterNumValue(bubbles[index]);
		}
		
		/**
		 */		
		override public function setXml(series:XML):void
		{
			var xml:XML = <{type} seriesName={name} xField={labelField} yField={valueField} radiusField='z'/>;
			
			series.appendChild(xml);
		}
		
		
		/**
		 */		
		public var bubbles:Array;
	}
}
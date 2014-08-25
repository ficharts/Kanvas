package view.editor.chart
{
	import com.kvs.utils.RexUtil;

	public class BarSeriesProxy extends SeriesProxy
	{
		public function BarSeriesProxy()
		{
			super();
		}
		
		/**
		 * 
		 */			
		override public function applyData(data:XML, index:uint):void
		{
			data.@[valueField] = labels[index];
			data.@[labelField] = RexUtil.filterNumValue(values[index]);
		}
		
		/**
		 */		
		override public function get labelField():String
		{
			return 'x' + index.toString();;
		}
		
		/**
		 */		
		override public function get  valueField():String
		{
			return 'y' 
		}
	}
}
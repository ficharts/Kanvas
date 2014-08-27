package view.editor.chart
{
	import com.kvs.utils.RexUtil;

	/**
	 *
	 * 用户辅助生成序列和图表的数据模型
	 * 
	 * 不同序列的模型会有一点差异，通过继承此类来应对差异化
	 *  
	 * @author wanglei
	 * 
	 */	
	public class SeriesProxy
	{
		public function SeriesProxy()
		{
		}
		
		/**
		 */		
		public function appendFfix(pre:String, suf:String, confg:XML):void
		{
			confg.@ySuffix = suf;
			confg.@yPrefix = pre;
		}
		
		/**
		 */		
		public function applyData(data:XML, index:uint):void
		{
			data.@[labelField] = labels[index];
			data.@[valueField] = RexUtil.filterNumValue(values[index]);
		}
		
		/**
		 */		
		public function setXml(series:XML):void
		{
			var xml:XML = <{type} seriesName={name} xField={labelField} yField={valueField}/>;
			
			series.appendChild(xml);
		}
		
		/**
		 */		
		public var index:uint;
		
		/**
		 */		
		public var type:String;
		
		/**
		 */		
		public var name:String;
		
		/**
		 */		
		public function get labelField():String
		{
			return 'x';
		}
		
		/**
		 */		
		public function get  valueField():String
		{
			return 'y'  + index.toString();
		}
		
		/**
		 */		
		public var values:Array;
		
		/**
		 * 
		 */		
		public var labels:Array;
	}
}
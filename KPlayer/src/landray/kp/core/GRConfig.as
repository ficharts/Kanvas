package landray.kp.core
{
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import landray.kp.view.Graph;

	public class GRConfig
	{
		public function GRConfig($graph:Graph)
		{
			initialize($graph);
		}
		private function initialize($graph:Graph):void
		{
			graph  = $graph;
			themes = new Map;
			lib    = new XMLVOLib;
		}
		public var graph   :Graph;
		public var templete:XML;
		public var themes  :Map;
		public var lib     :XMLVOLib;
		public var theme   :String;
	}
}
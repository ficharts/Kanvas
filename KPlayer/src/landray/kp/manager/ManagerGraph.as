package landray.kp.manager
{
	public class ManagerGraph
	{
		public  static const instance:ManagerGraph = new ManagerGraph;
		private static var   created :Boolean;
		public function ManagerGraph()
		{
			if(!created) 
			{
				created = true;
				super();
				initialize();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		
		private function initialize():void
		{
			graphs = {};
		}
		
		public function registGraph(name:String, reference:Class):Boolean
		{
			var result:Boolean = true;
			if (reference) {
				if (graphs[name]) {
					result = false;
				} else graphs[name] = reference;
			} else result = false;
			return result;
		}
		
		public function removeGraph(name:String):void
		{
			delete graphs[name];
		}
		
		public function getGraph(name:String):Class
		{
			return graphs[name];
		}
		
		private var graphs:Object;
	}
}
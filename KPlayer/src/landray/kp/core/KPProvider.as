package landray.kp.core
{

	public final class KPProvider
	{
		public  static const instance:KPProvider = new KPProvider;
		private static var   created :Boolean;
		public function KPProvider()
		{
			if(!created) 
			{
				created = true;
				super();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		
		public var dataXML :XML;
		
		public var styleXML:XML;
	}
}
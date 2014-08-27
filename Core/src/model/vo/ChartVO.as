package model.vo
{
	/**
	 */	
	public class ChartVO extends ElementVO
	{
		public function ChartVO()
		{
			super();
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			var xml:XML = super.exportData();
			
			xml.appendChild(config);
			
			return xml;
		}
		
		/**
		 */		
		override public function clone():ElementVO
		{
			var target:ElementVO = super.clone();
			
			(target as ChartVO).config = config.copy();
				
			
			return target;
		}
		
		/**
		 */		
		private var _config:Object
		
		public function get config():Object
		{
			return _config;
		}

		public function set config(value:Object):void
		{
			_config = value;
		}

	}
		
		
}
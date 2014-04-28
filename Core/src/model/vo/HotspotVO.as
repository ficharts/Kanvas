package model.vo
{
	/**
	 * 热点图的模型
	 */	
	public class HotspotVO extends ElementVO
	{
		public function HotspotVO()
		{
			super();
			
			styleType = type = 'hotspot';
			styleID = 'Hot';
		}
	}
}
package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.HotspotVO;
	
	
	/**
	 * 热点图
	 */	
	public final class Hotspot extends Element 
	{
		public function Hotspot($vo:HotspotVO)
		{
			super($vo);
			alpha = 0;
			//buttonMode = true;
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				StyleManager.drawRect(this, vo.style, vo);
			}
		}

	}
}
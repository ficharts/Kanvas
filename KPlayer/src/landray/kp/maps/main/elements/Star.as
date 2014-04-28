package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.StarVO;
	
	/**
	 * 星形
	 */	
	public class Star extends Element
	{
		public function Star(vo:StarVO)
		{
			super(vo);
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				StyleManager.drawStar( this, vo.style, starVO.innerRadius, vo );
			}
		}
		
		/**
		 */		
		private function get starVO():StarVO
		{
			return vo as StarVO;
		}
		
	}
}
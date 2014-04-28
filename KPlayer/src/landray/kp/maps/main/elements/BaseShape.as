package landray.kp.maps.main.elements
{	
	import model.vo.ShapeVO;
	
	/**
	 * 图形基类
	 */
	public class BaseShape extends Element
	{
		/**
		 * 
		 */		
		public function BaseShape($vo:ShapeVO)
		{
			super($vo);
		}
		
		protected function get shapeVO():ShapeVO
		{
			return vo as ShapeVO;
		}
		
	}
}
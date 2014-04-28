package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.LineVO;
	
	/**
	 * 线条
	 */	
	public class Line extends Element
	{
		public function Line($vo:LineVO)
		{
			super($vo);
		}
		
		/**
		 */		
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				StyleManager.setLineStyle(graphics, vo.style.getBorder, vo.style, vo);
				graphics.moveTo(- lineVO.width / 2, 0);
				graphics.curveTo(0, lineVO.arc * 2, lineVO.width / 2, 0);
			}
		}
		
		override public function get topLeft():Point
		{
			tlPoint.x = vo.scale * - .5 * vo.width;
			tlPoint.y = vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
			return caculateTransform(tlPoint);
		}
		
		override public function get topCenter():Point
		{
			tcPoint.x = 0;
			tcPoint.y = vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
			return caculateTransform(tcPoint);
		}
		
		override public function get topRight():Point
		{
			trPoint.x = vo.scale *   .5 * vo.width;
			trPoint.y = vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
			return caculateTransform(trPoint);
		}
		
		override public function get middleLeft():Point
		{
			mlPoint.x = vo.scale * - .5 * vo.width;
			mlPoint.y = vo.scale *   .5 * lineVO.arc;
			return caculateTransform(mlPoint);
		}
		
		override public function get middleCenter():Point
		{
			mcPoint.x = 0;
			mcPoint.y = vo.scale * .5 * lineVO.arc;
			return caculateTransform(mlPoint);
		}
		
		override public function get middleRight():Point
		{
			mrPoint.x = vo.scale * .5 * vo.width;
			mrPoint.y = vo.scale * .5 * lineVO.arc;
			return caculateTransform(mrPoint);
		}
		
		override public function get bottomLeft():Point
		{
			blPoint.x = vo.scale * - .5 * vo.width;
			blPoint.y = vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
			return caculateTransform(blPoint);
		}
		
		override public function get bottomCenter():Point
		{
			bcPoint.x = 0;
			bcPoint.y = vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
			return caculateTransform(bcPoint);
		}
		
		override public function get bottomRight():Point
		{
			brPoint.x = vo.scale *   .5 * vo.width;
			brPoint.y = vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
			return caculateTransform(brPoint);
		}
		
		override public function get top():Number
		{
			return vo.scale *(- .5 * vo.height + ((lineVO.arc < 0) ? lineVO.arc : 0));
		}
		
		override public function get bottom():Number
		{
			return vo.scale *(  .5 * vo.height + ((lineVO.arc>= 0) ? lineVO.arc : 0));
		}
		
		
		/**
		 */		
		protected function get lineVO():LineVO
		{
			return vo as LineVO;
		}
	}
}
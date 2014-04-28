package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ArrowVO;
		
	/**
	 * 双箭头
	 */	
	public final class DoubleArrow extends BaseShape
	{
		public function DoubleArrow($vo:ArrowVO)
		{
			super($vo);
		}
		
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				StyleManager.setShapeStyle( arrowVO.style, graphics, arrowVO );
				
				// 从箭头的顶点开始绘制，顺时针绕一圈
				graphics.moveTo(   .5 * arrowVO.width, 0 );
				graphics.lineTo(   .5 * arrowVO.width - arrowVO.arrowWidth,   .5 * arrowVO.height );
				graphics.lineTo(   .5 * arrowVO.width - arrowVO.arrowWidth,   .5 * arrowVO.trailHeight );
				
				graphics.lineTo( - .5 * arrowVO.width + arrowVO.arrowWidth,   .5 * arrowVO.trailHeight );
				graphics.lineTo( - .5 * arrowVO.width + arrowVO.arrowWidth,   .5 * arrowVO.height );
				
				graphics.lineTo( - .5 * arrowVO.width, 0 );
				
				graphics.lineTo( - .5 * arrowVO.width + arrowVO.arrowWidth, - .5 * arrowVO.height );
				graphics.lineTo( - .5 * arrowVO.width + arrowVO.arrowWidth, - .5 * arrowVO.trailHeight );
				
				graphics.lineTo(   .5 * arrowVO.width - arrowVO.arrowWidth, - .5 * arrowVO.trailHeight );
				graphics.lineTo(   .5 * arrowVO.width - arrowVO.arrowWidth, - .5 * arrowVO.height );
				graphics.moveTo(   .5 * arrowVO.width, 0 );
				
				graphics.endFill();
			}
		}
		
		protected function get arrowVO():ArrowVO
		{
			return vo as ArrowVO;
		}
		
	}
}
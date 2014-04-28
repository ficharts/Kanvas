package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ArrowVO;
	
	
	/**
	 * 单箭头
	 */	
	public class Arrow extends BaseShape
	{
		public function Arrow($vo:ArrowVO)
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
				graphics.moveTo(   arrowVO.width * .5, 0 );
				graphics.lineTo(   arrowVO.width * .5 -arrowVO.arrowWidth, arrowVO.height * .5 );
				graphics.lineTo(   arrowVO.width * .5 -arrowVO.arrowWidth, arrowVO.trailHeight * .5 );
				graphics.lineTo( - arrowVO.width * .5, arrowVO.trailHeight * .5 );
				
				//--------------------中轴线--------------------------------------------------------------
				
				graphics.lineTo( - arrowVO.width * .5,-arrowVO.trailHeight * .5 );
				graphics.lineTo(   arrowVO.width * .5 -arrowVO.arrowWidth, -arrowVO.trailHeight * .5 );
				graphics.lineTo(   arrowVO.width * .5 -arrowVO.arrowWidth, -arrowVO.height * .5 );
				graphics.lineTo(   arrowVO.width * .5, 0 );
				
				graphics.endFill();
			}
		}
		
		/**
		 */		
		protected function get arrowVO():ArrowVO
		{
			return vo as ArrowVO;
		}
	}
	
}
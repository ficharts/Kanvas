package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.geom.Point;
	
	import model.vo.DialogVO;
	import model.vo.ShapeVO;
	
	public final class Dialog extends BaseShape
	{
		public function Dialog($vo:ShapeVO)
		{
			super($vo);
		}
		
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				//先绘制遮罩图形
				vo.style.radius = dialogVO.radius * 2;
				
				var rad:Number = dialogVO.rAngle / 180 * Math.PI;
				var cP:Point = new Point(dialogVO.r * Math.cos(rad), dialogVO.r * Math.sin(rad));
				
				var r:Number;
				
				if (vo.width > vo.height)
					r = vo.height / 4;
				else 
					r = vo.width / 4;
				
				var nRad:Number = rad - Math.PI / 2; 
				var rP:Point = new Point(r * Math.cos(nRad), r * Math.sin(nRad));
				
				nRad = rad + Math.PI / 2;
				var lP:Point = new Point(r * Math.cos(nRad), r * Math.sin(nRad));
				
				StyleManager.drawRect(this, vo.style, vo);
				StyleManager.setShapeStyle(vo.style, graphics, vo);
				graphics.moveTo(cP.x, cP.y);
				graphics.lineTo(rP.x, rP.y);
				graphics.lineTo(lP.x, lP.y);
				graphics.lineTo(cP.x, cP.y);
				graphics.endFill();
			}
		}
		
		/**
		 */		
		protected function get dialogVO():DialogVO
		{
			return vo as DialogVO;
		}
	}
}
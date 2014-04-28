package landray.kp.maps.mind.utils
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Graphics;
	
	import landray.kp.maps.mind.core.mm_internal;
	import landray.kp.maps.mind.model.BezierLineVO;
	import landray.kp.maps.mind.model.TreeElementVO;
	import landray.kp.maps.mind.view.TreeElement;
	

	public final class MindMapUtil
	{
		use namespace mm_internal;
		
		/**
		 * 更新TreeElementVO的子集水平与竖直方向
		 */
		public static function updateTreeElementVODirection(vo:TreeElementVO):void
		{
			var l:uint = vo.children.length;
			var m:int = -1;
			var h:int = -1;
			var v:int = 1;
			for (var i:int = 0; i < l; i++) 
			{
				v *= m;
				h *= v;
				vo.children[i].vDirection = (v > 0) ? "bottom" : "top";
				vo.children[i].hDirection = (vo.level == 1) 
					? ((h < 0) ? "left" : "right") 
					: vo.hDirection;
			}
		}
		
		/**
		 * 获取TreeElement高度，children为是否包含子元素的高度
		 */
		public static function getElementHeight(element:TreeElement, children:Boolean = true):Number
		{
			var height:Number = element.richText.height +  element.vo.vGap * 2;
			if(element.vo.expand && children)
			{
				var tempHeight:Number = 0;
				for (var i:int = 0; i < element.childs.length; i++) 
					tempHeight += getElementHeight(element.childs[i]);
				if (tempHeight > height)
					height = tempHeight;
			}
			return height;
		}
		
		/**
		 * 获取TreeElement元素宽度
		 */
		public static function getElementWidth(element:TreeElement):Number
		{
			var width:Number = element.richText.width;
			width += element.vo.hGap * 2;
			return width; 
		}
		
		/**
		 * 获取TreeElement元素划线起始点X
		 */
		public static function getElementLineStartX(element:TreeElement):Number
		{
			return element.x + ((element.vo.level <= 1) ? 0 : (element.richText.width * .5 + element.vo.btnGap) * ((element.vo.hDirection == "right") ? 1 : -1));
		}
		
		/**
		 * 获取TreeElement元素划线起始点Y
		 */
		public static function getElementLineStartY(element:TreeElement):Number
		{
			return element.y;
		}
		
		/**
		 * 获取TreeElement元素划线终止点X
		 */
		public static function getElementLineEndX(element:TreeElement):Number
		{
			var x:Number;
			if (element.vo.level == 2)
				x = element.x + element.richText.width * ((element.vo.hDirection == "right") ? -.5 : .5);
			else if (element.vo.level > 2)
				x = element.x + (element.richText.width * .5) * ((element.vo.hDirection == "right") ? 1 : -1);
			return x;
		}
		
		/**
		 * 获取TreeElement元素划线终止点Y
		 */
		public static function getElementLineEndY(element:TreeElement):Number
		{
			var y:Number;
			if (element.vo.level == 2)
				y = element.y;
			else if (element.vo.level > 2)
				y = element.y + element.richText.height * .5;
			return y;
		}
		
		public static function renderLine(graphics:Graphics, vo:BezierLineVO):void
		{
			StyleManager.setLineStyle(graphics, vo.style.getBorder, vo.style, vo);
			
			graphics.moveTo(vo.startX, vo.startY);
			if (vo.startX < vo.endX)
			{
				if (vo.endElement.vo.level > 2)
					graphics.cubicCurveTo(vo.startX, vo.endY, vo.startX, vo.endY, vo.endX, vo.endY);
				else
					graphics.cubicCurveTo(vo.startX + 50, vo.startY, vo.endX - 50, vo.endY, vo.endX, vo.endY);
			}
			else
			{
				if (vo.endElement.vo.level > 2)
					graphics.cubicCurveTo(vo.startX, vo.endY, vo.startX, vo.endY, vo.endX, vo.endY);
				else
					graphics.cubicCurveTo(vo.startX - 50, vo.startY, vo.endX + 50, vo.endY, vo.endX, vo.endY);
			}
		}
	}
}